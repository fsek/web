class Api::ContactsSerializer < ActiveModel::Serializer
  include ContactHelper

  class Api::ContactsSerializer::Show < Api::ContactsSerializer
    attributes(:email, :name, :text, :avatar)
    attribute(:users) { object.users.collect { |u| u.firstname + " " + u.lastname } }

    def avatar
      if contact_single_user(object)
        object.users.first.avatar
      else
        object.avatar
      end
    end
  end

  class Api::ContactsSerializer::Index < Api::ContactsSerializer
    attributes(:id, :email, :name, :text, :avatar)
    attribute(:users) { object.users.collect { |u| u.firstname + " " + u.lastname } }

    def avatar
      if contact_single_user(object)
        object.users.first.avatar
      else
        object.avatar
      end
    end

    def text
      MarkdownHelper.markdown_api(object.text)
    end
  end
end
