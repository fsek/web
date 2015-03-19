module ApplicationHelper
  def fa_icon(icon_name)
    content_tag :i, nil, class: ("fa fa-" + icon_name)
  end

  def title(page_title)
    content_for(:title) { page_title }
  end

  def full_title(page_title)
    base_title = "F-sektionen"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  def breadcrumb_bar(*args, &block)
    if block_given?
      content_for(:breadcrumb_bar, &block)
    else
      content_for(:breadcrumb_bar) { args.shift }
    end

    breadcrumb *args
  end

  def standard_form_for(object, &block)
    form_for object, builder: StandardFormBuilder, html: { class: 'sky-form' }, &block
  end
end
