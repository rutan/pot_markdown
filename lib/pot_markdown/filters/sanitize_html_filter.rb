require 'nokogiri'
require 'sanitize'

require 'pot_markdown/filters/sanitize_transformers/id_transformer'
require 'pot_markdown/filters/sanitize_transformers/list_transformer'
require 'pot_markdown/filters/sanitize_transformers/table_transformer'

module PotMarkdown
  module Filters
    class SanitizeHTMLFilter < HTML::Pipeline::Filter
      def call
        Sanitize.clean_node!(doc, rule)
      end

      RULE = {
        elements: %w(
          a
          b
          blockquote
          br
          code
          dd
          del
          details
          div
          dl
          dt
          em
          h1
          h2
          h3
          h4
          h5
          h6
          hr
          i
          img
          input
          ins
          kbd
          li
          ol
          p
          pre
          q
          rp
          rt
          ruby
          s
          samp
          span
          strike
          strong
          sub
          summary
          sup
          table
          tbody
          td
          tfoot
          th
          thead
          tr
          tt
          ul
          var
        ),
        attributes: {
          all: %w(
            abbr
            align
            alt
            border
            cellpadding
            cellspacing
            cite
            class
            color
            cols
            colspan
            datetime
            height
            hreflang
            id
            itemprop
            lang
            name
            rowspan
            style
            tabindex
            target
            title
            width
          ) + [:data],
          'a' => %w(
            href
          ),
          'div' => %w(
            itemscope
            itemtype
          ),
          'iframe' => %w(
            allowfullscreen
            frameborder
            src
            scrolling
          ),
          'img' => %w(
            src
          ),
          'input' => %w(
            checked
            disabled
            type
          ),
          'script' => %w(
            src
          )
        },
        css: {
          properties: %w(
            border
            color
            height
            text-align
            width
          )
        },
        protocols: {
          'a' => {
            'href' => ['http', 'https', :relative]
          },
          'img' => {
            'src' => ['http', 'https', :relative]
          }
        },
        transformers: [
          SanitizeTransformers::IdTransformer,
          SanitizeTransformers::ListTransformer,
          SanitizeTransformers::TableTransformer
        ]
      }.freeze

      RULE_EXT = RULE.dup.tap do |rule|
        rule[:elements] += %w(script iframe)
      end

      private

      def rule
        if context[:sanitize_rule]
          context[:sanitize_rule]
        elsif context[:sanitize_use_external]
          RULE_EXT
        else
          RULE
        end
      end
    end
  end
end
