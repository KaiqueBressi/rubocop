# frozen_string_literal: true

# TODO: when finished, run `rake generate_cops_documentation` to update the docs
module RuboCop
  module Cop
    module Metrics
      # This cop checks if the number of statements of the method exceeds some maximum value.
      # The maximum allowed statement number is configurable.

      class PerceivedMethodLength < Cop
        LABEL = 'Method'
        MSG = '%<label>s has too many statements. [%<length>d/%<max>d]'

        def on_def(node)
          @statements = 0
          require 'pry'; binding.pry

          return unless count_statements(extract_body(node)) > max_statements

          add_offense(node, location: :name, message: message(@statements, max_statements))
        end

        private

        def message(length, max_length)
          format(MSG, label: cop_label, length: length, max: max_length)
        end

        def max_statements
          cop_config['Max']
        end

        def count_statements(node)
          return 0 unless node

          if compound_statement?(node)
            node.node_parts.each(&method(:count))
          else
            count(node)
          end

          @statements
        end

        def count(node)
          if has_body?(node)
            @statements += 1
            puts node.type

            count_statements(extract_body(node))
          else
            @statements += 1
            puts node.type
          end
        end

        def compound_statement?(node)
          node.type == :begin || node.type == :kwbegin
        end

        def extract_body(node)
          if has_body?(node)
            node.body
          else
            node
          end
        end

        def has_body?(node)
          node.respond_to?(:body)
        end

        def cop_label
          LABEL
        end
      end
    end
  end
end
