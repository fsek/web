module MarkdownHelper
  require 'redcarpet/render_strip'

  def markdown(text)
    MarkdownHelper.markdown(text)
  end

  def self.markdown(text)
    if text.present?
      sanitize(markdown_renderer.render(text))
    end
  end

  def markdown_plain(text)
    MarkdownHelper.markdown_plain(text)
  end

  def self.markdown_plain(text)
    if text.present?
      sanitize(plain_renderer.render(text))
    end
  end

  def self.markdown_renderer
    Redcarpet::Markdown.new(Redcarpet::Render::HTML,
                            autolink: true,
                            fenced_code_blocks: true,
                            highlight: true,
                            lax_spacing: true,
                            no_intra_emphasis: true,
                            quote: true,
                            tables: true,
                            underline: true)
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

  def self.sanitize(input)
    if input.present?
      ActionView::Base.new.sanitize(input.html_safe)
    end
  end
end
