module Trb1
  module Declarative
    module Inspect
      def inspect
        string = super
        if is_a?(Proc)
          elements = string.split("/")
          string = "#{elements.first}#{elements.last}"
        end
        string.gsub(/0x\w+/, "")
      end

      module Schema
        def inspect
          definitions.extend(Definitions::Inspect)
          "Schema: #{definitions.inspect}"
        end
      end
    end

    module Definitions::Inspect
      def inspect
        each { |dfn|
          dfn.extend(Trb1::Declarative::Inspect)

          if dfn[:nested] && dfn[:nested].is_a?(Trb1::Declarative::Schema::DSL)
            dfn[:nested].extend(Trb1::Declarative::Inspect::Schema)
          else
            dfn[:nested].extend(Trb1::Declarative::Definitions::Inspect) if dfn[:nested]
          end
        }
        super
      end

      def get(*)
        super.extend(Trb1::Declarative::Inspect)
      end
    end
  end
end
