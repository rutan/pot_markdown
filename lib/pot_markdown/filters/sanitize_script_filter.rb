require 'nokogiri'
require 'sanitize'

module PotMarkdown
  module Filters
    class SanitizeScriptFilter < HTML::Pipeline::Filter
      def call
        doc.xpath('.//script').each do |element|
          if safe?(element)
            element.children.remove
          else
            element.remove
          end
        end
        doc
      end

      SAFE_SCRIPT_URL = [
        # nicovideo
        %r{\Ahttps?://ext.nicovideo.jp/thumb_watch/[^/]+\z},

        # speakerdeck
        %r{\A(https?:)?//speakerdeck.com/assets/embed.js\z},

        # pixiv
        %r{\Ahttps?://source.pixiv.net/source/embed.js\z},

        # twitter
        %r{\A(https:)?//platform.twitter.com/widgets.js\z},

        # gist
        %r{\Ahttps://gist.github.com/[A-Za-z0-9\-]+/[a-f0-9]+\.js\z}
      ].freeze

      private

      def safe?(element)
        src = element['src']
        safe_script_list.any? { |reg| src =~ reg }
      end

      def safe_script_list
        context[:safe_script_url] || SAFE_SCRIPT_URL
      end
    end
  end
end
