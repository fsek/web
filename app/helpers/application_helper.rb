module ApplicationHelper
  def yes_no(value)
    if value
      I18n.t('global.yes')
    else
      I18n.t('global.no')
    end
  end

  def model_name(model)
    if model.instance_of?(Class)
      model.model_name.human
    end
  end

  def models_name(model)
    if model.instance_of?(Class)
      model.model_name.human(count: 2)
    end
  end

  def form_group &block
    html = Nokogiri::HTML.fragment(capture(&block))
    html.xpath('input|textarea').each do |e|
      if e['class']
        e['class'] += ' form-control '
      else
        e['class'] = 'form-control '
      end
    end
    content_tag :div, raw(html.to_html), class: 'form-group'
  end

  def responsive_video(url)
    if url.present?
      content_tag(:div, class: 'responsive-video') do
        content_tag(:iframe, '', src: url, frameborder: 0)
      end
    end
  end

  def active_list_group(first, second)
    if first == second
      'list-group-item active'
    else
      'list-group-item'
    end
  end
end
