module Dry
  module Swagger
    class ContractParser
      PREDICATE_TO_TYPE = {
          array?: 'array',
          bool?: 'boolean',
          date?: 'date',
          date_time?: 'datetime',
          decimal?: 'float',
          float?: 'float',
          hash?: 'hash',
          int?: 'integer',
          nil?: 'nil',
          str?: 'string',
          time?: 'time'
      }.freeze

      SWAGGER_FIELD_TYPE_DEFINITIONS = {
          "string" => { type: :string },
          "integer" => { type: :integer },
          "boolean" => { type: :boolean },
          "float" => { type: :float },
          "datetime" => { type: :string, format: :datetime },
          "date" => { type: :string, format: :date },
          "time" => { type: :string, format: :time },
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

      # @api private
      def call(contract, &block)
        @keys = {}
        visit(contract.schema.to_ast)
        instance_eval(&block) if block_given?
        to_swagger
      end

      # @api private
      def visit(node, opts = {})
        meth, rest = node
        public_send(:"visit_#{meth}", rest, opts)
      end

      # @api private
      def visit_set(node, opts = {})
        target = (key = opts[:key]) ? self.class.new : self

        node.map { |child| target.visit(child, opts) }

        return unless key

        target_info = opts[:member] ? target.to_h : target.to_h
        type = keys[key][:array] ? 'array' : 'hash'

        keys.update(key => { **keys[key], type: type, **target_info })
      end

      # @api private
      def visit_and(node, opts = {})
        left, right = node

        visit(left, opts)
        visit(right, opts)
      end

      def visit_not(_node, opts = {})
        key = opts[:key]
        keys[key][::Dry::Swagger.nullable_type] = true if ::Dry::Swagger.contract_enable_nullable_validation
      end

      # @api private
      def visit_implication(node, opts = {})
        node.each do |el|
          opts = opts.merge(required: false) if ::Dry::Swagger.contract_enable_required_validation
          visit(el, opts)
        end
      end

      # @api private
      def visit_each(node, opts = {})
        visit(node, opts.merge(member: true))
      end

      # @api private
      def visit_key(node, opts = {})
        name, rest = node
        opts = opts.merge(key: name)
        opts = opts.merge(required: true) if ::Dry::Swagger.contract_enable_required_validation
        visit(rest, opts)
      end

      # @api private
      def visit_predicate(node, opts = {})
        name, rest = node

        key = opts[:key]

        if name.equal?(:key?)
          keys[rest[0][1]] = { required: opts.fetch(:required, true) } if ::Dry::Swagger.contract_enable_required_validation
        elsif name.equal?(:array?)
          keys[key][:array] = true
        elsif name.equal?(:included_in?)
          keys[key][:enum] = rest[0][1]
        elsif PREDICATE_TO_TYPE[name]
          keys[key][:type] = PREDICATE_TO_TYPE[name]
        else
          description = predicate_description(name.to_s, rest[0][1].to_s)
          if keys[key][:description].to_s.empty?
            keys[key][:description] = description unless description.to_s.empty?
          else
            keys[key][:description] += ", #{description}" unless description.to_s.empty?
          end
        end
      end

      def predicate_description(name, validation)
        case name
        when 'eql?' then "Must be equal to #{validation}"
        when 'max_size?' then "Maximum size: #{validation}"
        when 'min_size?' then "Minimum size: #{validation}"
        when 'gteq?' then "Greater or equal #{validation}"
        when 'gt?' then "Greater than #{validation}"
        when 'lt?' then "Lower than #{validation}"
        when 'lteq?' then "Lower than or equal to #{validation}"
        else
          ''
        end
      end

      def to_swagger
        generate_documentation(keys)
      end

      private

      def generate_documentation(fields)
        documentation = { properties: {}, required: [] }
        fields.each do |field_name, attributes_hash|
          documentation[:properties][field_name] = generate_field_properties(attributes_hash)
          documentation[:required] << field_name if ::Dry::Swagger.contract_enable_required_validation && attributes_hash[:required]
        end
        { :type => :object, :properties => documentation[:properties], :required => documentation[:required] }
      end

      def generate_field_properties(attributes_hash)
        if attributes_hash[:type] == 'array'
          { type: :array, items: generate_documentation(attributes_hash[:keys]) }
        elsif attributes_hash[:array] && attributes_hash[:type] != 'array'
          { type: :array, items: SWAGGER_FIELD_TYPE_DEFINITIONS.fetch(attributes_hash[:type]) }
        elsif attributes_hash[:type] == 'hash'
          generate_documentation(attributes_hash[:keys])
        else
          field = SWAGGER_FIELD_TYPE_DEFINITIONS.fetch(attributes_hash[:type])
          field = field.merge(::Dry::Swagger.nullable_type => attributes_hash[::Dry::Swagger.nullable_type] | false) if ::Dry::Swagger.contract_enable_nullable_validation
          field = field.merge(enum: attributes_hash[:enum]) if attributes_hash[:enum] if ::Dry::Swagger.contract_enable_enums
          field = field.merge(description: attributes_hash[:description]) if attributes_hash[:description] if ::Dry::Swagger.contract_enable_descriptions
          field
        end
      end
    end
  end
end