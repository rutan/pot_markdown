module Kramdown
  module Parser
    class PotMarkdown
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
    end
  end
end
