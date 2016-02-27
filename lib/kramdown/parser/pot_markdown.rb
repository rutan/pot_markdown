require 'kramdown/parser'
require 'rouge'

module Kramdown
  module Parser
    class PotMarkdown < Kramdown::Parser::GFM
      def initialize(source, options)
        super
        @span_parsers << :strikethrough_pot unless methods.include?(:parse_strikethrough_gfm)
      end

      def parse_atx_header
        # ↓ removed in pot_markdown
        # return false if !after_block_boundary?

        start_line_number = @src.current_line_number
        @src.check(ATX_HEADER_MATCH)
        level = @src[1]
        text = @src[2].to_s.strip
        id = @src[3]
        return false if text.empty?

        @src.pos += @src.matched_size
        el = new_block_el(:header, nil, nil, level: level.length, raw_text: text, location: start_line_number)
        add_text(text, el)
        el.attr['id'] = id if id
        @tree.children << el
        true
      end

      FENCED_CODEBLOCK_MATCH = /^(([~`]){3,})\s*?((\w[\w\:\.-]*)(?:\?\S*)?)?\s*?\n(.*?)^\1\2*\s*?\n/m

      def parse_codeblock_fenced
        if @src.check(self.class::FENCED_CODEBLOCK_MATCH)
          start_line_number = @src.current_line_number
          @src.pos += @src.matched_size
          el = new_block_el(:codeblock, @src[5], nil, location: start_line_number)
          lang = @src[3].to_s.strip
          unless lang.empty?
            lang, filename = lang.split(':', 2)
            if filename.nil? && lang.include?('.')
              filename = lang
              lang = Rouge::Lexer.guess_by_filename(filename).name.match(/[^\:]+\z/).to_s.downcase
            end
            el.options[:lang] = lang
            el.attr['data-lang'] = lang
            if filename
              el.attr['class'] = "language-#{lang} has-filename"
              el.attr['data-filename'] = filename
            else
              el.attr['class'] = "language-#{lang}"
            end
          end
          @tree.children << el
          true
        else
          false
        end
      end

      unless instance_methods.include?(:parse_strikethrough_gfm)
        STRIKETHROUGH_POT_DELIMITER = /~~/

        def parse_strikethrough_pot
          start_line_number = @src.current_line_number
          result = @src.scan(STRIKETHROUGH_POT_DELIMITER)
          saved_pos = @src.save_pos

          if @src.pre_match =~ /\s\Z/ && @src.match?(/\s/)
            add_text(result)
            return
          end

          text = @src.scan_until(/#{result}/)
          if text
            text.sub!(/#{result}\Z/, '')
            del = Element.new(:html_element, 'del', {}, category: :span, line: start_line_number)
            del.children << Element.new(:text, text, category: :span, line: start_line_number)
            @tree.children << del
          else
            @src.revert_pos(saved_pos)
            add_text(result)
          end
        end

        define_parser(:strikethrough_pot, STRIKETHROUGH_POT_DELIMITER, '~')
      end
    end
  end
end
