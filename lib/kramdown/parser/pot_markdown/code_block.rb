module Kramdown
  module Parser
    class PotMarkdown
      FENCED_CODEBLOCK_START = /^[ ]{0,3}[~`]{3,}/
      FENCED_CODEBLOCK_MATCH = /^[ ]{0,3}(([~`]){3,})\s*?((\S+?)(?:\?\S*)?)?\s*?\n(.*?)^[ ]{0,3}\1\2*\s*?\n/m

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
    end
  end
end
