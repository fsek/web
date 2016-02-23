module ContactHelper
  def contact_link(contact)
    if contact.present?
      text = safe_join([fa_icon('envelope'), ' ', contact.full_string])
      link_to(text, contact_path(contact))
    end
  end

  def contact_from_slug(slug:)
    contact = Contact.find_by(slug: slug)
    contact_link(contact)
  end

  def contact_image(contact)
    if contact_single_user(contact)
      image_tag(avatar_user_path(contact.post.users.first),
                class: 'img-responsive')
    else
      image_tag('missing_thumb.png', class: 'img-responsive')
    end
  end

  def contact_single_user(contact)
    contact.users.count == 1 &&
      contact.users.first.present? &&
      contact.users.first.avatar.present?
  end
end