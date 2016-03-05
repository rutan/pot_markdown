require 'test_helper.rb'
require 'benchmark/ips'

class BenchmarkTest < Test::Unit::TestCase
  def text
    @text = File.read(File.expand_path('../../files/sample.md', __FILE__))
  end

  test 'each filter' do
    text; # load
    context = {
      asset_root: '/'
    }
    Benchmark.ips do |x|
      PotMarkdown::Processor::DEFAULT_FILTERS.each do |filter|
        x.report(filter.name) { filter.new(text, context).call }
      end
      x.compare!
    end
  end

  test 'benchmark integration' do
    text; # load
    Benchmark.ips do |x|
      x.report('pot_markdown') { PotMarkdown::Processor.new.call(text)[:output].to_s }

      begin
        require 'qiita-markdown'
        x.report('qiita_markdown') { Qiita::Markdown::Processor.new.call(text)[:output].to_s }
      rescue LoadError
        puts 'skip benchmark test'
      end

      x.compare!
    end
  end
end
