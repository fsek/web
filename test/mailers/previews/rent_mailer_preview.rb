# Preview all emails at http://localhost:3000/rails/mailers/cafe_mailer
class RentMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/cafe_mailer/rent_email
  def rent_email
    rent = Rent.new(id: 18, d_from: "2015-02-07 09:48:00", d_til: "2015-02-09 07:00:00", name: "David", lastname: "Wessman", email: "davidwessman@live.se", phone: "0705607889", purpose: "", disclaimer: true, aktiv: true, council_id: nil, profile_id: 1,  status: "Bekräftad")
    RentMailer.rent_email(rent)
  end

  # Preview this email at http://localhost:3000/rails/mailers/cafe_mailer/status_email
  def status_email
    RentMailer.status_email(Rent.new(id: 18, d_from: "2015-02-07 09:48:00", d_til: "2015-02-09 07:00:00", name: "David", lastname: "Wessman", email: "davidwessman@live.se", phone: "0705607889", purpose: "", disclaimer: true, aktiv: true, council_id: nil, profile_id: 1, created_at: "2015-02-06 08:01:44", updated_at: "2015-02-07 09:47:31", comment: "KAOS", status: "Nekad", services: nil))
  end

end
