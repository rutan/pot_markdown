require 'nokogiri'
require 'sanitize'

module PotMarkdown
  module Filters
    class MentionFilter < HTML::Pipeline::MentionFilter
      USER_NAME_PATTERN = /[A-Za-z0-9][A-Za-z0-9\-\_]+/

      def call
        result[:mentioned_usernames] ||= []

        doc.xpath('.//text()').each do |node|
          content = node.text
          next unless content.include?('@')
          next if has_ancestor?(node, IGNORE_PARENTS)
          html = mention_link_filter(content, base_url, info_url, username_pattern)
          next if html == content
          node.replace(html)
        end
        doc
      end

      def username_pattern
        context[:username_pattern] || USER_NAME_PATTERN
      end

      def link_to_mentioned_user(login)
        result[:mentioned_usernames] |= [login]
        "<a href='#{base_url}#{login}' class='user-mention'>@#{login}</a>"
      end
    end
  end
end
