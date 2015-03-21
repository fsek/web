require 'test_helper'

class NoticeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "invalid without a title description and sort" do
    c = Notice.new
    assert !c.valid?, "Title, description and sort is not validated"
  end

  #test "publish and remove days are set even when not entered" do
    #assert
  #end

  # Published is a notice that should be inside the published query
  # /d.wessman
  test "published-notice is contained in published-query" do
    n = notices(:published)
    assert_includes(Notice.published,n, %(#{n.to_s} is not in query) )
  end
  # not_published is a notice that shouldn't be inside the published query
  # /d.wessman
  test "not-published-notice is not included in published-query" do
    n = notices(:not_published)
    assert_not_includes(Notice.published,n,%(The unpublished notice #{n.to_s} is in query))
  end

  # Should not return notices with public: false
  # /d.wessman
  test 'not-public-notice should not be in public_published query ' do
    n = notices(:published_not_public)
    assert_not_includes(Notice.public_published,n,%(The not-public notice #{n.to_s} is in query))
  end

  # Should return objects where public: true
  # /d.wessman
  test 'public-notice should be in public_published query ' do
    n = notices(:published)
    assert_includes(Notice.public_published,n,%(The public notice #{n.to_s} is not in query))
  end

end
