module PostHelper
  def print_post_limit(post)
    if post.present?
      if post.rec_limit == 0 && post.limit == 0 || post.rec_limit > post.limit
        '*'
      elsif post.rec_limit == post.limit && post.rec_limit > 0
        %(#{post.limit} (x))
      elsif post.limit > 0 && post.rec_limit == 0
        post.limit
      elsif post.limit > post.rec_limit
        %(#{post.rec_limit} - #{post.limit})
      end
    end
  end

  def post_tab_header(posts)
    if posts.present?
      content_tag(:ul, class: 'nav nav-tabs') do
        content = []
        content << post_tab_link(posts.first, first: true)
        posts.offset(1).each do |post|
          content << post_tab_link(post)
        end
        safe_join(content)
      end
    end
  end

  def post_tab(posts)
    if posts.present?
      content = []
      content << post_tab_element(posts.first, first: true)
      posts.offset(1).each do |post|
        content << post_tab_element(post)
      end
      safe_join(content)
    end
  end

  def post_tab_element(post, first: false)
    if first
      content_tag(:div, id: dom_id(post), class: 'tab-pane fade in active') do
        safe_join([post_tab_description(post), post_tab_users(post)])
      end
    else
      content_tag(:div, id: dom_id(post), class: 'tab-pane fade in') do
        safe_join([post_tab_description(post), post_tab_users(post)])
      end
    end
  end

  def post_tab_link(post, first: false)
    if post.present?
      if first
        content_tag(:li, class: :active) do
          link_to(post, %(##{dom_id(post)}), data: { toggle: :tab })
        end
      else
        content_tag(:li) do
          link_to(post, %(##{dom_id(post)}), data: { toggle: :tab })
        end
      end
    end
  end

  def post_tab_description(post)
    if post.present?
      content_tag(:div, class: 'col-sm-8') do
        content = []
        content << content_tag(:div, class: :headline) do
          content_tag(:h4) do
            Post.human_attribute_name(:description)
          end
        end
        content << markdown(post.description)
        safe_join(content)
      end
    end
  end

  def post_tab_users(post)
    if post.present?
      content_tag(:div, class: 'col-sm-4') do
        content = []
        content << content_tag(:div, class: :headline) do
          content_tag(:h4) do
            t('helper.post.who_currently')
          end
        end
        content << post_users_list(post)
        safe_join(content)
      end
    end
  end

  def post_users_list(post)
    if post.present?
      content_tag(:ul, class: :list) do
        content = []

        post.users.each do |user|
          content << content_tag(:li) do
            user_link(user)
          end
        end

        safe_join(content)
      end
    end
  end
end
