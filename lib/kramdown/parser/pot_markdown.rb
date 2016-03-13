require 'kramdown/parser'
require 'rouge'

module Kramdown
  module Parser
    class PotMarkdown < Kramdown::Parser::GFM
      def initialize(source, options)
        super

        # replace table
        @block_parsers.insert(@block_parsers.index(:table), :table_pot)
        @block_parsers.delete(:table)
      end

      require 'kramdown/parser/pot_markdown/atx_header'
      require 'kramdown/parser/pot_markdown/code_block'
      require 'kramdown/parser/pot_markdown/table'
    end
  end
end
