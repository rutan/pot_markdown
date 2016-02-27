require 'test_helper.rb'
require 'benchmark/ips'

class BenchmarkTest < Test::Unit::TestCase
  def text
    @text = File.read(File.expand_path('../../files/sample.md', __FILE__))
  end

  test 'each filter' do
    text; # load
    Benchmark.ips do |x|
      [
        PotMarkdown::Filters::MarkdownFilter,
        PotMarkdown::Filters::MentionFilter,
        PotMarkdown::Filters::SanitizeHTMLFilter,
        PotMarkdown::Filters::SanitizeIframeFilter,
        PotMarkdown::Filters::SanitizeScriptFilter,
        PotMarkdown::Filters::TOCFilter
      ].each do |filter|
        x.report(filter.name) { filter.new(text).call }
      end
      x.compare!
    end
  end

  begin
    require 'qiita-markdown'

    test 'benchmark with qiita-markdown' do
      text; # load
      Benchmark.ips do |x|
        x.report('pot_markdown') { PotMarkdown::Processor.new.call(text)[:output].to_s }
        x.report('qiita_markdown') { Qiita::Markdown::Processor.new.call(text)[:output].to_s }
        x.compare!
      end
    end
  rescue LoadError
    puts 'skip benchmark test'
  end
end
