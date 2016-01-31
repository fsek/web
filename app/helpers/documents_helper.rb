module DocumentsHelper
  def document_button_text(category)
    if category.present?
      category
    else
      I18n.t('document.categories')
    end
  end

  def document_dropdown_button(collection:, current:)
    content = safe_join([document_button(current), document_collection(collection)])
    content_tag(:div, content, class: 'dropdown')
  end

  def document_button(current)
    content = safe_join([document_button_text(current), ' ', content_tag(:span, '', class: 'caret')])
    content_tag(:button, content, class: 'btn primary dropdown-toggle',
                                  id: 'document_dropdown', type: 'button',
                                  data: { toggle: 'dropdown' },
                                  aria: { haspopup: 'true', expanded: 'true' })
  end

  def document_collection(collection)
    categories = [content_tag(:li, link_to(t('document.all_categories'), documents_path))]
    collection.each { |c| categories << document_category_link(c) }
    content_tag(:ul, safe_join(categories), class: 'dropdown-menu',
                                            aria: { labelled_by: 'document_dropdown' })
  end

  def document_category_link(category)
    content_tag(:li, link_to(category, documents_path(category: category)))
  end
end
