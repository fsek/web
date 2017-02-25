module NewsHelper
  include CategoriesHelper

  def news_user(news)
    if news.present? && news.user.present?
      content_tag(:span, class: :link) do
        link_to(news.user, target: :blank) do
          fa_icon('user') + ' ' + news.user
        end
      end
    end
  end

  def news_dropdown_button(collection:, current:)
    content = safe_join([category_button(current), news_collection(collection)])
    content_tag(:div, content, class: 'dropdown')
  end

  def news_collection(collection)
    categories = []
    collection.each do |cat|
      categories << news_category_link(cat)
    end

    category_collection(categories, news_index_path)
  end

  def news_category_link(category)
    category_link(category, news_index_path(category: category.to_param))
  end
end
