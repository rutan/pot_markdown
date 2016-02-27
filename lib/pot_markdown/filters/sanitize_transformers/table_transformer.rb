module PotMarkdown
  module Filters
    module SanitizeTransformers
      class TableTransformer
        def self.call(*args)
          new(*args).transform
        end

        def initialize(env)
          @env = env
          @name = env[:node_name]
          @node = env[:node]
        end

        attr_reader :name, :node

        def transform
          return unless NAMES.include?(name)
          return if node.ancestors.any? { |n| n.name == LIST_PARENT }

          node.replace(node.children)
        end

        NAMES = Set.new(%w(thead tbody tfoot tr td th)).freeze
        LIST_PARENT = 'table'.freeze
      end
    end
  end
end
