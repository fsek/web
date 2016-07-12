module MetaTagsHelper
  def description(text)
    if text.present?
      set_meta_tags(description: text,
                    twitter: { description: text },
                    og: { description: text })
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
      set_meta_tags(image: image,
                    twitter: { image: image },
                    og: { image: image })
    end
    image
  end
end
