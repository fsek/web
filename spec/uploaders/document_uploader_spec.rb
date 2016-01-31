require 'rails_helper'
require 'carrierwave/test/matchers'

RSpec.describe DocumentUploader do
  include CarrierWave::Test::Matchers
  let(:document) { create(:document) }
  let(:uploader) { DocumentUploader.new(document, :file) }

  before do
    DocumentUploader.enable_processing = true

    File.open('spec/assets/pdf.pdf') do |f|
      uploader.store!(f)
    end
  end

  after do
    DocumentUploader.enable_processing = false
    uploader.remove!
  end

  context 'uploaded document' do
    it 'has the proper filename' do
      uploader.filename.should eq('pdf.pdf')
    end
  end
end
