module MarkdownHelper
  def markdown(text)
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
