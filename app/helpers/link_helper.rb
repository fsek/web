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
end
