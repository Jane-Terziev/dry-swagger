module Dry
  module Swagger
    class StructParser
      PREDICATE_TYPES = {
          String: 'string',
          Integer: 'integer',
          Bool: 'boolean',
          Float: 'float',
          Date: 'date',
          DateTime: 'datetime',
          Time: 'time'
      }.freeze

      # @api private
      attr_reader :keys

      # @api private
      def initialize
        @keys = {}
      end

      # @api private
      def to_h
        { keys: keys }
      end

      def call(dto, &block)
        @keys = {}
        visit(dto.schema.to_ast)
        instance_eval(&block) if block_given?
        self
      end

      # @api private
      def visit(node, opts = {})
        meth, rest = node
        public_send(:"visit_#{meth}", rest, opts)
      end

      def visit_constructor(node, opts = {})
        visit(node[0], opts)
      end

      def visit_schema(node, opts = {})
        target = (key = opts[:key]) ? self.class.new : self

        required = opts.fetch(:required, true)
        nullable = opts.fetch(:nullable, false)

        node[0].each do |child|
          target.visit(child)
        end

        return unless key

        target_info =  target.to_h if opts[:member]

        type = opts[:array]? 'array' : 'hash'

        keys[key] = {
            type: type,
            required: required,
            ::Dry::Swagger.nullable_type => nullable,
            **target_info
        }
      end

      def visit_key(node, opts = {})
        name, required, rest = node
        opts[:key] = name
        opts[:required] = required
        visit(rest, opts)
      end

      def visit_constrained(node, opts = {})
        node.each {|it| visit(it, opts) }
      end

      def visit_nominal(_node, _opts); end

      def visit_predicate(node, opts = {})
        name, rest = node
        type = rest[0][1]

        if name.equal?(:type?)
          type = type.to_s.to_sym
          return unless PREDICATE_TYPES[type]

          type_definition = {
              type: PREDICATE_TYPES[type],
              required: opts.fetch(:required),
              ::Dry::Swagger.nullable_type => opts.fetch(:nullable, false)
          }

          type_definition[:array] = opts[:array] if opts[:array]

          keys[opts[:key]] = type_definition
        elsif name.equal?(:included_in?)
          type += [nil] if opts.fetch(:nullable, false)
          keys[opts[:key]][:enum] = type
        end
      end

      # @api private
      def visit_and(node, opts = {})
        left, right = node

        visit(left, opts)
        visit(right, opts)
      end

      def visit_enum(node, opts = {})
        visit(node[0], opts)
      end

      def visit_sum(node, opts = {})
        opts[:nullable] = true
        visit(node[1], opts)
      end

      def visit_struct(node, opts = {})
        opts[:member] = true

        visit(node[1], opts)
      end

      def visit_array(node, opts = {})
        opts[:array] = true
        visit(node[0], opts)
      end

      def to_swagger
        ::Dry::Swagger::DocumentationGenerator.new.generate_documentation(keys)
      end
    end
  end
end