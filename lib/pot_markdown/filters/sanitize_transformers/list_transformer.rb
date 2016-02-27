module PotMarkdown
  module Filters
    module SanitizeTransformers
      class ListTransformer
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
          return unless @name == NAME
          return if node.ancestors.any? { |n| LIST_PARENT.include?(n.name) }

          node.replace(node.children)
        end

        NAME = 'li'.freeze
        LIST_PARENT = Set.new(%w(ul ol)).freeze
      end
    end
  end
end
