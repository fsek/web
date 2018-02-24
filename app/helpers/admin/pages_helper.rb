module Admin::PagesHelper
  def page_element_types
    [[t('model.page_element.text'), PageElement::TEXT],
     [t('model.page_element.image'), PageElement::IMAGE]]
  end
end
