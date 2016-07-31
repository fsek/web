module BlogPostsHelper
  def blog_post_dropdown_button(collection:, current:)
    content = safe_join([category_button(current), blog_posts_collection(collection)])
    content_tag(:div, content, class: 'dropdown')
  end

  def blog_posts_collection(collection)
    categories = []
    collection.each do |cat|
      categories << blog_post_category_link(cat)
    end

    category_collection(categories, blog_posts_path)
  end

  def blog_post_category_link(category)
    category_link(category, blog_posts_path(category: category.to_param))
  end
end
