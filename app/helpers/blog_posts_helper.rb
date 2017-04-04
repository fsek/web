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

  def blog_post_translated?(blog_post)
    unless blog_post.is_translated?(I18n.locale)
      content_tag(:div, class: 'alert alert-info') do
        content = []
        content << content_tag(:button, fa_icon('times'),
                               type: 'button', class: 'close',
                               data: { dismiss: 'alert' })
        content << I18n.t('model.blog_post.not_translated')
        safe_join(content)
      end
    end
  end

  def blog_title(blog_post, meta: false, link: false)
    title = content_tag(:h1) do
      (meta ? title(blog_post.title) : blog_post.title)
    end

    if link
      link_to(title, blog_post_path(blog_post))
    else
      title
    end
  end

  def blog_cover_image(url)
    content_tag(:div, '', class: 'cover-image',
                style: "background: url('#{url}') no-repeat center center; background-size: contain;")
  end
end
