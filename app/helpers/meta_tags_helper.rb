module MetaTagsHelper
  def description(text)
    if text.present?
      tag_text = truncate(text, length: 155)
      set_meta_tags(description: tag_text,
                    twitter: { description: tag_text },
                    og: { description: tag_text })
    end
    text
  end

  def title(text)
    if text.present?
      set_meta_tags(title: text,
                    twitter: { title: text },
                    og: { title: text })
    end
    text
  end

  def meta_image(image)
    if image.present?
      url = image_url(image)
      set_meta_tags(image: url,
                    twitter: { image: url },
                    og: { image: url })
    end
    image
  end
end
