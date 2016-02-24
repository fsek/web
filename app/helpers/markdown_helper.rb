module MarkdownHelper
  require 'redcarpet/render_strip'
  def markdown(text)
    if text.present?
      sanitize(markdown_renderer.render(text))
    end
  end

  def markdown_plain(text)
    if text.present?
      sanitize(plain_renderer.render(text))
    end
  end

  def markdown_renderer
    Redcarpet::Markdown.new(Redcarpet::Render::HTML,
                            no_intra_emphasis: true,
                            fenced_code_blocks: true,
                            autolink: true,
                            tables: true,
                            underline: true,
                            highlight: true)
  end

  def plain_renderer
    Redcarpet::Markdown.new(Redcarpet::Render::StripDown,
                            no_intra_emphasis: true,
                            fenced_code_blocks: true,
                            autolink: true,
                            tables: true,
                            underline: true,
                            highlight: true)
  end

  def sanitize(input)
    if input.present?
      ActionView::Base.new.sanitize(input.html_safe)
    end
  end
end
