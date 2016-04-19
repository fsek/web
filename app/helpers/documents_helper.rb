module DocumentsHelper
  include CategoriesHelper

  # Uses category button from CategoriesHelper to render the whole button
  def document_dropdown_button(collection:, current:)
    content = safe_join([category_button(current), document_collection(collection)])
    content_tag(:div, content, class: 'dropdown')
  end


  # Returns the collection of links fomr the CategoriesHelper.category_collection
  # Uses the index path to add a button for clearing query
  def document_collection(collection)
    categories = []
    collection.each do |cat|
      categories << document_category_link(cat)
    end

    category_collection(categories, documents_path)
  end

  # Returns the link of a button based on CategoriesHelper.category_link
  def document_category_link(category)
    category_link(category, documents_path(category: category.to_param))
  end
end
