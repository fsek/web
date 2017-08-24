module MarkdownHelper
  require 'redcarpet/render_strip'

  def markdown(text)
    MarkdownHelper.markdown(text)
  end

  def self.markdown_api(text)
    sanitize(api_renderer.render(text)) if text.present?
  end

  def self.markdown(text)
    sanitize(markdown_renderer.render(text)) if text.present?
  end

  def markdown_plain(text)
    MarkdownHelper.markdown_plain(text)
  end

  def self.markdown_plain(text)
    sanitize(plain_renderer.render(text)) if text.present?
  end

  def self.markdown_renderer
    options = {
      hard_wrap: true,
      link_attributes: { rel: 'nofollow', 'data-turbolinks': 'false' }
    }
    extensions = {
      autolink: true, fenced_code_blocks: true, highlight: true,
      lax_spacing: true, no_intra_emphasis: true, quote: true,
      tables: true, underline: true
    }

    Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(options),
                            extensions)
  end

  def self.plain_renderer
    Redcarpet::Markdown.new(Redcarpet::Render::StripDown,
                            no_intra_emphasis: true,
                            fenced_code_blocks: true,
                            autolink: true,
                            tables: true,
                            underline: true,
                            highlight: true)
  end

  def self.api_renderer
    options = {
      hard_wrap: true,
      link_attributes: { class: 'external', target: '_system' }
    }
    extensions = {
      autolink: true, fenced_code_blocks: true, highlight: true,
      lax_spacing: true, no_intra_emphasis: true, quote: true,
      tables: true, underline: true
    }

    Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(options),
                            extensions)
  end

  def self.sanitize(input)
    return unless input.present?
    ActionView::Base.new.sanitize(input.html_safe,
                                  attributes: %w(href data-turbolinks rel class target))
  end
end
