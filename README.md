# PotMarkdown

PotMarkdown is markdown processor for [Potmum](https://github.com/rutan/potmum).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pot_markdown'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pot_markdown

## Usage

```ruby
require 'pot_markdown'

processor = PotMarkdown::Processor.new
context = {
  safe_script_url: false
}
processor.call("# title\n\n Hello, **Potmum!** ...", context)
# => {
#  toc: "<ul><li><a href=\"#id-title\">title ...",
#  output: "<h1 id=\"id-title\">title</h1>...",
#  mentioned_usernames: ['rutan', ...]
# }
```

## context

- `anchor_icon`
    - header link icon
    - default)
        - `<i class="fa fa-link"></i>`
- `sanitize_rule`
    - [sanitize gem](https://github.com/rgrove/sanitize) parameters.
- `sanitize_use_external`
    - to enable the particular script/iframe
    - ex)
        - Youtube
        - Twitter
        - niconico
        - SlideShare
        - and more... (see SanitizeIframeFilter and SanitizeScriptFilter)
- `safe_iframe_url`
    - enable iframe url, if use sanitize_use_external
- `safe_script_url`
    - enable script url, if use sanitize_use_external

### others

PotMarkdown used these filters.

- HTML::Pipeline::AutolinkFilter
- HTML::Pipeline::EmojiFilter
- HTML::Pipeline::MentionFilter

please see [html-pipeline](https://github.com/jch/html-pipeline) documents :)

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/rutan/pot_markdown

