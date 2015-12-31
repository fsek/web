module LinkHelper
  def link(obj, options = {})
    if obj.nil?
      content_tag :i, '[missing]'
    elsif obj.is_a?(ActiveRecord::Base) && obj.respond_to?(:name)
      link_to obj.name, obj, options
    elsif obj.respond_to? :model_name
      link_to obj.model_name.human(count: 2), obj
    else
      link_to obj, obj, options
    end
  end

  def user_link(obj, options = {})
    if obj.present? && obj.is_a?(User)
      link_to(obj, user_path(obj), options)
    else
      obj
    end
  end
end
