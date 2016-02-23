module MarkdownHelper
  require 'redcarpet/render_strip'
  def markdown(text)
    if text.present?
      markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML,
                                         no_intra_emphasis: true,
                                         fenced_code_blocks: true,
                                         autolink: true,
                                         tables: true,
                                         underline: true,
                                         highlight: true)
      ActionView::Base.new.sanitize(markdown.render(text).html_safe)
    end
  end

  def markdown_plain(text)
    if text.present?
      markdown = Redcarpet::Markdown.new(Redcarpet::Render::StripDown,
                                         no_intra_emphasis: true,
                                         fenced_code_blocks: true,
                                         autolink: true,
                                         tables: true,
                                         underline: true,
                                         highlight: true)
      ActionView::Base.new.sanitize(markdown.render(text).html_safe)
    end
  end
end
