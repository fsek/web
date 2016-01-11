module NewsHelper
  def news_url(news)
    if news.present? && news.url.present?
      content_tag(:span, class: :link) do
        link_to(news.url, target: :blank) do
          fa_icon('link') + ' ' + news.url
        end
      end
    end
  end

  def news_user(news)
    if news.present? && news.user.present?
      content_tag(:span, class: :link) do
        link_to(news.user, target: :blank) do
          fa_icon('user') + ' ' + news.user
        end
      end
    end
  end
end
