module ApplicationHelper
  def yes_no(value)
    if value
      I18n.t('global.yes')
    else
      I18n.t('global.no')
    end
  end

  def fa_icon(icon_name)
    content_tag(:i, nil, class: "fa fa-#{icon_name}")
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

  def localized(date, options: {})
    if date.present?
      I18n.l(date, options)
    else
      fa_icon('cogs')
    end
  end
end
