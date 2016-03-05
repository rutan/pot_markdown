require 'html/pipeline'

require 'pot_markdown/filters/markdown_filter'
require 'pot_markdown/filters/sanitize_html_filter'
require 'pot_markdown/filters/sanitize_script_filter'
require 'pot_markdown/filters/sanitize_iframe_filter'
require 'pot_markdown/filters/mention_filter'
require 'pot_markdown/filters/toc_filter'
require 'pot_markdown/filters/checkbox_filter'

module PotMarkdown
  class Processor
    def initialize(default_context = {})
      @default_context = DEFAULT_CONTEXT.merge(default_context)
    end

    def call(str, context = {})
      HTML::Pipeline.new(filters, @default_context.merge(context)).call(str)
    end

    def filters
      @filters ||= DEFAULT_FILTERS.dup
    end

    DEFAULT_CONTEXT = {
      asset_root: '/assets'
    }.freeze

    DEFAULT_FILTERS = [
      PotMarkdown::Filters::MarkdownFilter,
      PotMarkdown::Filters::TOCFilter,
      PotMarkdown::Filters::MentionFilter,
      PotMarkdown::Filters::CheckboxFilter,
      HTML::Pipeline::AutolinkFilter,
      HTML::Pipeline::EmojiFilter,
      PotMarkdown::Filters::SanitizeHTMLFilter,
      PotMarkdown::Filters::SanitizeScriptFilter,
      PotMarkdown::Filters::SanitizeIframeFilter
    ].freeze
  end
end
