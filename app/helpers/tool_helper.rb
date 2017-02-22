module ToolHelper
  def tool_link(tool, path)
    if tool.present?
      content = []
      content << content_tag(:h4, tool.title, class: 'list-group-item-heading')
      content << content_tag(:span, tool.free.to_s, class: 'badge')
      content << content_tag(:p, tool.description, class: 'list-group-item-text')

      make_link(tool, path, content)
    end
  end

  private

  def make_link(tool, path, content)
    class_str = ['list-group-item', 'list-group-item-tools']
    if tool.free.zero?
      class_str << ' list-group-item-danger'
    end

    link_to path, class: class_str do
      safe_join(content)
    end
  end
end
