require 'rails_helper'

RSpec.describe PageService do
  describe 'upload images' do
    it 'valid attributes' do
      page = create(:page)
      page.image_upload = [Rack::Test::UploadedFile.new(File.open('app/assets/images/hilbert.jpg'))]

      lambda do
        PageService.upload_images(page)
      end.should change(PageImage, :count).by(1)
    end
  end
end
