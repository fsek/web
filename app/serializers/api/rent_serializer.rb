class Api::RentSerializer < ActiveModel::Serializer
  class Api::RentSerializer::Show < ActiveModel::Serializer
    # Replace p_time with d_from, d_til
    attributes(:id, :user, :council, :d_from, :d_til, :status, :purpose)
    def user
      {name: object.user.firstname + " "+ object.user.lastname,
       email: object.user.email,
       lucat: object.user.student_id,
       phone: object.user.phone}
    end
    def council
      object.council.title
    end

  end
end