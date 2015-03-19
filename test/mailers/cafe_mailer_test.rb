require 'test_helper'

class CafeMailerTest < ActionMailer::TestCase
  test "sign_up_email" do
    mail = CafeMailer.sign_up_email
    assert_equal "Sign up email", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "sign_off_email" do
    mail = CafeMailer.sign_off_email
    assert_equal "Sign off email", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
