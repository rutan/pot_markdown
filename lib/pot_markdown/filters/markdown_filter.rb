require 'nokogiri'
require 'kramdown'
require 'kramdown/parser/pot_markdown'

module PotMarkdown
  module Filters
    class MarkdownFilter < HTML::Pipeline::TextFilter
      def initialize(text, context = nil, result = nil)
        super
        @text = @text.delete("\r").strip
      end

      def call
        Nokogiri::HTML.fragment Kramdown::Document.new(
          @text,
          input: 'PotMarkdown',
          auto_id_prefix: 'id-',
          syntax_highlighter: 'rouge',
          math_engine: nil
        ).to_html.rstrip!
      end
    end
  end
end
