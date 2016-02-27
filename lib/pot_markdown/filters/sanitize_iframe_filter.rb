require 'nokogiri'
require 'sanitize'

module PotMarkdown
  module Filters
    class SanitizeIframeFilter < HTML::Pipeline::Filter
      def call
        doc.xpath('.//iframe').each do |element|
          element.remove unless safe?(element)
        end
        doc
      end

      SAFE_IFRAME_URL = [
        # youtube
        %r{\Ahttps://www.youtube.com/embed/[^/]+\z},

        # nicovideo
        %r{\Ahttps?://ext.nicovideo.jp/thumb/[^/]+\z},

        # nicolive
        %r{\Ahttps?://live.nicovideo.jp/embed/.+\z},

        # nicoseiga
        %r{\Ahttps?://ext.seiga.nicovideo.jp/thumb/[^/]+\z},

        # niconisolid
        %r{\Ahttps?://3d.nicovideo.jp/externals/(?:widget|embedded)\?id=td\d+\z},

        # slideshare
        %r{\A(https?:)?//www.slideshare.net/slideshow/embed_code/key/[^/]+\z},

        # plicy
        %r{\Ahttps?://plicy.net/GameEmbed/\d+\z}
      ].freeze

      private

      def safe?(element)
        src = element['src']
        safe_iframe_list.any? { |reg| src =~ reg }
      end

      def safe_iframe_list
        context[:safe_iframe_url] || SAFE_IFRAME_URL
      end
    end
  end
end
