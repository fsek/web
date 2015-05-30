require 'rails_helper'
require 'cancan_matchers'

describe Ability do

  not_signed_in = {
    album: { yes: [], no: [:read, :new, :edit] },
    cafe_work: {
      yes: [:read],
      no: [:new, :edit, :add_worker, :update_worker, :remove_worker, :nyckelpiga]
    },
    candidate: { yes: [], no: [:read, :new, :edit] },
    constant: { yes: [], no: [:read, :new, :edit] },
    contact: { yes: [:read, :mail], no: [:new, :edit] },
    council: { yes: [:read], no: [:new, :edit] },
    document: { yes: [:read], no: [:new, :edit] },
    election: { yes: [:index], no: [:new, :edit] },
    event: { yes: [], no: [:read, :new, :edit] },
    faq: { yes: [:read, :new], no: [:update, :edit] },
    menu: { yes: [], no: [:read, :new, :edit] },
    news: { yes: [:read], no: [:new, :edit] },
    nomination: { yes: [], no: [:new, :create] },
    notice: { yes: [:display, :image], no: [:read, :new, :edit] },
    page_element: { yes: [], no: [:read, :new, :edit] },
    page: { yes: [:read], no: [:new, :edit] },
    permission: { yes: [], no: [:read, :new, :edit] },
    post: { yes: [:collapse, :display], no: [:index, :new, :edit] },
    rent: { yes: [:main], no: [:new, :edit] }
  }

  describe 'not_signed_in' do
    subject(:ability) { Ability.new(nil) }

    not_signed_in.each do |key, value|
      if value[:yes].present?
        it { should have_abilities(value[:yes], key.to_s.singularize.classify.constantize.new) }
      end

      if value[:no].present?
        it { should not_have_abilities(value[:no], key.to_s.singularize.classify.constantize.new) }
      end
    end
  end
end
