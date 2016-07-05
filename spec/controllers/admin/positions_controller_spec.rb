require 'rails_helper'

RSpec.describe Admin::PositionsController, type: :controller do
  let(:user) { create(:user) }

  allow_user_to(:manage, Position)
  allow_user_to(:manage, Council)

  before(:each) do
    allow(controller).to receive(:current_user) { user }
  end

  describe 'GET #edit' do
    it 'assigns the requested position as @position' do
      council = create(:council)
      position = create(:position, council: council)

      get(:edit, id: position.to_param, council_id: council.to_param)
      assigns(:position).should eq(position)
      response.status.should eq(200)
    end
  end

  describe 'GET #new' do
    it 'assigns a new position as @position' do
      council = create(:council)
      get(:new, council_id: council.to_param)

      assigns(:position).new_record?.should be_truthy
      assigns(:position).instance_of?(Position).should be_truthy
      assigns(:position).council.should eq(council)
    end
  end

  describe 'GET #index' do
    it 'assigns position sorted as @positions' do
      council = create(:council)
      create(:position, council: council)
      create(:position, council: council)
      create(:position, council: council)

      get(:index, council_id: council.to_param)
      response.status.should eq(200)

      assigns(:positions).should eq(Position.all)
    end
  end

  describe 'POST #create' do
    it 'valid params' do
      council = create(:council)
      attributes = { title: 'Spindelman',
                     limit: 5,
                     rec_limit: 10,
                     semster: Position::AUTUMN,
                     elected_by: Position::BOARD,
                     description: 'En webbmästare' }

      lambda do
        post(:create, council_id: council.to_param, position: attributes)
      end.should change(Position, :count).by(1)

      response.should redirect_to(admin_council_positions_path(council))
    end

    it 'invalid params' do
      council = create(:council)
      attributes = { title: '',
                     description: 'En webbmästare' }

      lambda do
        post(:create, council_id: council.to_param, position: attributes)
      end.should change(Position, :count).by(0)

      response.status.should eq(422)
      response.should render_template(:new)
    end
  end

  describe 'PATCH #update' do
    it 'update position' do
      council = create(:council)
      position = create(:position, council: council, title: 'Spindelman')

      patch(:update, council_id: council.to_param,
                     id: position.to_param,
                     position: { title: 'Deadpool' })

      position.reload
      position.title.should eq('Deadpool')
      response.should redirect_to(edit_admin_council_position_path(council, position))
    end

    it 'invalid params' do
      council = create(:council)
      position = create(:position, council: council, title: 'Spindelman')

      patch(:update, council_id: council.to_param,
                     id: position.to_param,
                     position: { title: '' })

      position.reload
      position.title.should eq('Spindelman')
      response.should render_template(:edit)
      response.status.should eq(422)
    end
  end

  describe 'DELETE #destroy' do
    it 'works' do
      council = create(:council)
      position = create(:position, council: council)

      lambda do
        delete(:destroy, council_id: council.to_param, id: position.to_param)
      end.should change(Position, :count).by(-1)

      response.should redirect_to(admin_council_positions_path(council))
    end
  end
end
