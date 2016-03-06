module PageService
  def self.upload_images(page)
    state = true
    if page.image_upload.present?
      page.image_upload.each do |img|
        new_img = page.page_images.new(image: img)

        unless new_img.save
          page.errors.add(:image_upload, new_img.image)
          state = false
        end
      end
    end

    state
  end
end
