# Preview all emails at http://localhost:3000/rails/mailers/cafe_mailer
class CafeMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/cafe_mailer/sign_up_email
  def sign_up_email
    cw = CafeWork.new(id: 379, work_day: "2015-02-20 09:00:00", pass: 3, lp: 3, lv: 5, profile_id: 1, name: "David", lastname: "Wessman", phone: "0705607889", email: "davidwessman@live.se", utskottskamp: true, access_code: "ASDMOSBEOBSD6", d_year: 2015, created_at: "2015-02-18 13:35:54", updated_at: "2015-02-19 21:47:50")    
    CafeMailer.sign_up_email(cw)
  end

end
