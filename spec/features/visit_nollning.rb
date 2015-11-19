require 'rails_helper'
feature 'user visits nollning' do
  let(:user) { create(:user) }

  scenario 'Nollnings-controller: index' do
    page.visit(nollning_path)
    page.status_code.should eq(200)
  end

  scenario 'Nollnings-controller: matrix' do
    page.visit(nollning_matrix_path)
    page.status_code.should eq(200)
  end
end
