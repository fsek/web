# Set the host name for URL creation
puts PUBLIC_URL
SitemapGenerator::Sitemap.default_host = PUBLIC_URL
SitemapGenerator::Sitemap.sitemaps_path = 'sitemaps/'

SitemapGenerator::Sitemap.create do
  add root_path, priority: 1.0
  add news_index_path
  add documents_path
  add about_path
  add company_about_path
  add company_offer_path
  add new_user_registration_path
  add new_user_session_path

  add cafe_path
  add competition_cafe_path

  add rents_path

  add introductions_path

  add calendars_path

  add work_posts_path
  Page.publik.find_each do |page|
    add page_path(page), lastmod: page.updated_at
  end

  Council.find_each do |council|
    add council_path(council), lastmod: council.updated_at
  end

  Faq.answered.find_each do |faq|
    add faq_path(faq), lastmod: faq.updated_at
  end

  Contact.publik.find_each do |contact|
    add contact_path(contact), lastmod: contact.updated_at
  end

  Event.find_each do |event|
    add event_path(event), lastmod: event.updated_at
  end
end
