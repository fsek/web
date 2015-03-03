require 'test_helper'

class RentTest < ActiveSupport::TestCase

  # Disclaimer always has to be accepted
  # /d.wessman
  test "validates disclaimer" do
    r = rents(:david_d1_h12)
    r.disclaimer = false
    assert !r.valid?, "Disclaimer is not validated"
  end

  # Required attributes are:
  # :d_from,:d_til,:name,:lastname,:email,:phone.
  # /d.wessman
  test "validates presence of mandatory attributes, when missing" do
    r = rents(:david_d1_h12)
    r.name = ""
    assert !r.valid?, "Mandatory attributes not validated"
  end

  # Same as above.
  # /d.wessman
  test "validates presence of mandatory attributes, when present" do
    r = rents(:david_d1_h12)
    assert r.valid?, "Mandatory attributes is present but fails validation"
  end

  # Special validation for purpose, not required for members
  # /d.wessman
  test "validate presence of purpose if no profile" do
    r = rents(:no_profile)
    r.purpose = ""
    assert !r.valid?, "Purpose is not being validated when no profile"
  end

  # Validates the time of the booking, maximum 48h (except for councils)
  # /d.wessman
  test "validate length of booking, no council" do
    r = rents(:no_council)
    r.d_til = r.d_from + 50.hours
    assert !r.valid?, "Length of booking is not validated, no council"
  end

  # Same as above
  # /d.wessman
  test "validate length of booking, 48 h, no council" do
    r = rents(:no_council)
    r.d_til = r.d_from + 48.hours
    assert r.valid?, "Length of booking validated wrong, no council"
  end

  # Same as above, no limit for councils
  # /d.wessman
  test "length not validated, 50 h, council" do
    r = rents(:council)
    r.d_til = r.d_from + 50.hours
    assert r.valid?, "Length of booking validated wrong, council"
  end

  # Check that new dates are in the future,
  # /d.wessman
  test "dates in future" do
    r = Rent.new(name: "David", lastname: "Wessman", email: "davidwessman@live.se", disclaimer: true, phone: "0705607889",d_from: Time.zone.now + 50.hours )
    r.d_til = r.d_from  + 5.hours
    assert !r.valid?, "The dates are not validated"
  end

  # Check that d_from < d_til
  # /d.wessman
  test "d_from<d_til" do
    r = Rent.new(name: "David", lastname: "Wessman", email: "davidwessman@live.se", disclaimer: true, phone: "0705607889",d_from: Time.zone.now+50.hours )
    r.d_til = r.d_from - 10.hours
    assert !r.valid?, "The dates are not validated"
  end

  # Overlap validations

  # No councils, new.d_til is within saved
  # /d.wessman
  test "overlap of created and new, no councils, d_til within saved" do
    r = rents(:david_d10_h12_no_council)
    c = Rent.new(name: "David", lastname: "Wessman", email: "davidwessman@live.se", disclaimer: true, phone: "0705607889",d_from: r.d_from-5.hours, purpose: "s", d_til: r.d_til - 5.hours)
    assert !c.valid?, "Overlap is not validated"
  end

  # No councils, new.d_til & new.d_from within saved
  # /d.wessman
  test "overlap of created and new, no councils, d_from and d_til within saved" do
    r = rents(:david_d10_h12_no_council)
    c = Rent.new(name: "David", lastname: "Wessman", email: "davidwessman@live.se", disclaimer: true, phone: "0705607889",d_from: r.d_from+5.hours, purpose: "s", d_til: r.d_til - 5.hours)
    assert !c.valid?, "Overlap is not validated"
  end

  # No councils, new.d_from within saved
  # /d.wessman
  test "overlap of created and new, no councils, d_from within saved" do
    r = rents(:david_d10_h12_no_council)
    c = Rent.new(name: "David", lastname: "Wessman", email: "davidwessman@live.se", disclaimer: true, phone: "0705607889",d_from: r.d_from+5.hours, purpose: "s", d_til: r.d_til + 5.hours)
    assert !c.valid?, "Overlap is not validated"
  end

  # No councils, new outside saved
  # /d.wessman
  test "overlap of created and new, no councils, d_from and d_til outside saved" do
    r = rents(:david_d10_h12_no_council)
    c = Rent.new(name: "David", lastname: "Wessman", email: "davidwessman@live.se", disclaimer: true, phone: "0705607889",d_from: r.d_from + 20.hours , purpose: "s", d_til: r.d_til + 10.hours)
    assert c.valid?, "Overlap is not validated"
  end

  # Saved is council, new.d_til within saved
  # /d.wessman
  test "overlap of created and new, councils, d_til within saved" do
    r = rents(:david_d20_h12_council)
    c = Rent.new(name: "David", lastname: "Wessman", email: "davidwessman@live.se", disclaimer: true, phone: "0705607889",d_from: r.d_from-5.hours, purpose: "s", d_til: r.d_til - 5.hours)

    assert !c.valid?, "Overlap is not validated"
  end


  # Where new is council

  # Saved is not council, new.d_til within saved
  # /d.wessman
  test "with council overlap of created and new,saved not council, d_til within saved" do
    r = rents(:david_d10_h12_no_council)
    c = Rent.new(name: "David", lastname: "Wessman", email: "davidwessman@live.se", disclaimer: true, phone: "0705607889",d_from: r.d_from-5.hours, purpose: "s", d_til: r.d_til - 5.hours, council: Council.first)
    assert c.valid?, "Overlap is not validated"
  end

  # Saved is not council, new.d_from & d_til within
  # /d.wessman
  test "with council overlap of created and new, saved not council, d_from and d_til within saved" do
    r = rents(:david_d10_h12_no_council)
    c = Rent.new(name: "David", lastname: "Wessman", email: "davidwessman@live.se", disclaimer: true, phone: "0705607889",d_from: r.d_from+5.hours, purpose: "s", d_til: r.d_til - 5.hours, council: Council.first)
    assert c.valid?, "Overlap is not validated"
  end

  # Saved is not council, new.d_from within saved
  # /d.wessman
  test "with council overlap of created and new, saved not council, d_from within saved" do
    r = rents(:david_d10_h12_no_council)
    c = Rent.new(name: "David", lastname: "Wessman", email: "davidwessman@live.se", disclaimer: true, phone: "0705607889",d_from: r.d_from+5.hours, purpose: "s", d_til: r.d_til + 5.hours,council: Council.first)
    assert c.valid?, "Overlap is not validated"
  end

  # Saved is not council, new outside saved
  # /d.wessman
  test "with council overlap of created and new, saved not council, d_from and d_til outside saved" do
    r = rents(:david_d10_h12_no_council)
    c = Rent.new(name: "David", lastname: "Wessman", email: "davidwessman@live.se", disclaimer: true, phone: "0705607889",d_from: r.d_from + 20.hours , purpose: "s", d_til: r.d_til + 10.hours,council: Council.first)
    assert c.valid?, "Overlap is not validated"
  end

  # Saved is also council, new.d_til within
  # /d.wessman
  test "with council overlap of created and new, councils, d_til within saved" do
    r = rents(:david_d20_h12_council)
    c = Rent.new(name: "David", lastname: "Wessman", email: "davidwessman@live.se", disclaimer: true, phone: "0705607889",d_from: r.d_from-5.hours, purpose: "s", d_til: r.d_til - 5.hours,council: Council.first)

    assert !c.valid?, "Overlap is not validated, council should not be able to overbook council"
  end

  # Saved is not council, less than 5 days until saved starts
  # /d.wessman
  test "overlap of created and new, councils, d_til within saved AND<5 days until saved.d_from" do
    r = rents(:david_d4_h12_no_council)
    c = Rent.new(name: "David", lastname: "Wessman", email: "davidwessman@live.se", disclaimer: true, phone: "0705607889",d_from: r.d_from-5.hours, purpose: "s", d_til: r.d_til - 5.hours, council: Council.first)

    assert !c.valid?, "Overlap is not validated | only allowed if 120 < " + ((r.d_from - Time.zone.now)/3600).to_s
  end
end
