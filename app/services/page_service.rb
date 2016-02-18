class PageService
  attr_accessor :uploaded

  def initialize
    @uploaded = 0
  end

  def upload_images(page)
    state = true
    if page.image_upload.present?
      page.image_upload.each do |img|
        new_img = page.page_images.new(image: img)

        if new_img.save
          @uploaded += 1
        else
          page.errors.add(:image_upload, new_img.image)
          state = false
        end
      end
    end

    state
  end
end
