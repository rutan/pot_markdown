require 'nokogiri'

module PotMarkdown
  module Filters
    class TOCFilter < HTML::Pipeline::Filter
      def call
        result[:toc] = generate_toc(doc)
        doc
      end

      private

      def generate_toc(doc)
        toc = Nokogiri::XML::Document.new
        prev_level = nil

        Nokogiri::XML::Element.new('ul', doc).tap do |ul|
          doc.xpath('.//h1|.//h2|.//h3|.//h4|.//h5|.//h6').each do |element|
            level = element.name.delete('h').to_i
            prev_level = level unless prev_level

            diff = level - prev_level
            diff.abs.times do |_i|
              if diff > 0
                ul.add_child(Nokogiri::XML::Element.new('li', doc)) if ul.children.empty?
                old_ul = ul
                ul = Nokogiri::XML::Element.new('ul', doc)
                old_ul.children.last.add_child(ul)
              elsif ul.parent && ul.parent.parent
                ul = ul.parent.parent
              end
            end

            ul.add_child(create_item(toc, element))
            element.children.first.add_previous_sibling(create_jump_icon(doc, element))

            prev_level = level
          end
        end
      end

      def create_item(toc, element)
        Nokogiri::XML::Element.new('li', toc).tap do |li|
          link = Nokogiri::XML::Element.new('a', doc)
          link.set_attribute('href', "##{element['id']}")
          link.add_child(element.children.text.dup)
          li.add_child(link)
        end
      end

      def create_jump_icon(doc, element)
        Nokogiri::XML::Element.new('a', doc).tap do |link|
          link.set_attribute('href', "##{element['id']}")
          anchor_icon_html = Nokogiri::HTML.fragment(anchor_icon)
          link.add_child(anchor_icon_html)
        end
      end

      def anchor_icon
        context[:anchor_icon] || '<i class="fa fa-link"></i>'
      end
    end
  end
end
