module PotMarkdown
  module Filters
    class CheckboxFilter < HTML::Pipeline::Filter
      def call
        doc.xpath('.//li').each do |node|
          child = node.children.first
          next unless child
          next unless child.name == 'text'
          checkbox, text = checkbox_filter(child.text)
          next unless checkbox
          node.children.first.replace(text)
          node.children.first.add_previous_sibling(checkbox)
          node.set_attribute('class', "#{node.attribute('class')} #{checkbox_class}".strip)
        end
        doc
      end

      def checkbox_filter(text)
        checkbox = nil
        text = text.gsub(CHECKBOX_PATTERN) do
          checked = (Regexp.last_match(1) == 'x')
          checkbox =
            "<input type=\"checkbox\"#{' checked="checked"' if checked}#{' disabled="disabled"' if disable?} />"
          ''
        end
        [checkbox, text]
      end

      def disable?
        context[:checkbox_enable].nil? || context[:checkbox_enable]
      end

      def checkbox_class
        context[:checkbox_class] || 'task-list-item'
      end

      CHECKBOX_PATTERN = /\A\[(?<type>\s+|x)\]/
    end
  end
end
