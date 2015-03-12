module DocumentsHelper
  def no_docs(msg)
    return content_tag(:p, content_tag(:strong, msg))
  end
end
