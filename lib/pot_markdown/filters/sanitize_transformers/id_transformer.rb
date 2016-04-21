module PotMarkdown
  module Filters
    module SanitizeTransformers
      class IdTransformer
        def self.call(*args)
          new(*args).transform
        end

        def initialize(env)
          @env = env
          @node = env[:node]
        end

        attr_reader :node

        def transform
          return unless node.attribute('id')
          return if node.attribute('id').to_s =~ /\A(?:fn|id\-)/
          node.remove_attribute('id')
        end
      end
    end
  end
end
