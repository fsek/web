module ContactHelper
  def contact_link(contact)
    if contact.present?
      text = safe_join([fa_icon('envelope'), ' ', contact.name])
      link_to(text, contact_path(contact))
    end
  end

  # Takes name of a constant
  # Uses the constant value (an ID) to find a contact
  # Creates a link for Contact
  def contact_from_constant(constant:)
    contact_constant = Constant.find_by(name: constant).try(:value)
    contact = Contact.find_by(id: contact_constant)
    contact_link(contact)
  end
end
