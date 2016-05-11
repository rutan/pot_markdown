require 'test_helper.rb'

class ProcessorTest < Test::Unit::TestCase
  def render(text, context = {})
    PotMarkdown::Processor.new.call(text, context)[:output].to_s.strip
  end

  def render_toc(text, context = {})
    PotMarkdown::Processor.new.call(text, context)[:toc].to_s.strip
  end

  def render_body_diff(result, markdown, context = {})
    Diffy::Diff.new(render(markdown, context), result.strip).to_s
  end

  def render_toc_diff(result, markdown, context = {})
    Diffy::Diff.new(render_toc(markdown, context), result.strip).to_s
  end

  sub_test_case 'integration' do
    sub_test_case 'script enable' do
      test 'body' do
        diff = render_body_diff(
          read_file('sample_script_body.html'), read_file('sample.md'), sanitize_use_external: true
        )
        assert_true(diff.empty? ? true : (puts diff))
      end

      test 'toc' do
        diff = render_toc_diff(
          read_file('sample_script_toc.html'), read_file('sample.md'), sanitize_use_external: true
        )
        assert_true(diff.empty? ? true : (puts diff))
      end
    end

    sub_test_case 'script disable' do
      test 'body' do
        diff = render_body_diff(
          read_file('sample_noscript_body.html'), read_file('sample.md'), sanitize_use_external: false
        )
        assert_true(diff.empty? ? true : (puts diff))
      end

      test 'toc' do
        diff = render_toc_diff(
          read_file('sample_noscript_toc.html'), read_file('sample.md'), sanitize_use_external: false
        )
        assert_true(diff.empty? ? true : (puts diff))
      end
    end
  end

  test 'headers' do
    assert do
      text = <<-EOL
# h1
## h2
### h3
#### h4
##### h5
###### h6
      EOL
      result = <<-EOL
<h1 id="id-h1">
<a href=\"#id-h1\"><i class=\"fa fa-link\"></i></a>h1</h1>
<h2 id="id-h2">
<a href=\"#id-h2\"><i class=\"fa fa-link\"></i></a>h2</h2>
<h3 id="id-h3">
<a href=\"#id-h3\"><i class=\"fa fa-link\"></i></a>h3</h3>
<h4 id="id-h4">
<a href=\"#id-h4\"><i class=\"fa fa-link\"></i></a>h4</h4>
<h5 id="id-h5">
<a href=\"#id-h5\"><i class=\"fa fa-link\"></i></a>h5</h5>
<h6 id="id-h6">
<a href=\"#id-h6\"><i class=\"fa fa-link\"></i></a>h6</h6>
      EOL
      render(text) == result.rstrip!
    end
  end

  test 'strikethrough' do
    assert do
      text = 'strikethrough ~~text~~'
      render(text) == '<p>strikethrough <del>text</del></p>'
    end
  end

  test 'mention' do
    assert do
      text = '@Ru_shalm-san'
      render(text) == '<p><a href="/Ru_shalm-san" class="user-mention">@Ru_shalm-san</a></p>'
    end
  end

  sub_test_case 'script' do
    sub_test_case 'enable' do
      test 'remove script' do
        assert do
          text = <<-EOS
<script>alert(1)</script>
          EOS
          render(text, sanitize_use_external: true) == ''
        end
      end

      test 'safe script' do
        assert do
          text = <<-EOS
<script src="http://ext.nicovideo.jp/thumb_watch/sm28222250">remove text</script>
          EOS
          result = <<-EOS
<script src="http://ext.nicovideo.jp/thumb_watch/sm28222250"></script>
          EOS
          render(text, sanitize_use_external: true) == result.rstrip!
        end
      end
    end

    sub_test_case 'disable' do
      test 'remove wrapper tag' do
        assert do
          text = <<-EOS
<script>alert(1)</script>
          EOS
          render(text) == 'alert(1)'
        end
      end
    end
  end
end
