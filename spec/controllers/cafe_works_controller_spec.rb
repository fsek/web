require 'rails_helper'

RSpec.describe CafeWorksController, type: :controller do
  let(:user) { create(:user) }
  let(:not_owner) { create(:user) }
  let(:cwork_worker) { create(:cafe_work, :w_user, user: user) }
  let(:cwork) { create(:cafe_work) }

  allow_user_to [:show, :index, :update_worker, :remove_worker, :authorize], CafeWork

  describe 'GET #show' do
    it 'assigns the requested cafe_work as @cwork' do
      get(:show, id: cwork.to_param)
      assigns(:cafe_work).should eq(cwork)
    end
  end

  describe 'PATCH #update_worker' do
    context 'with valid params' do
      context 'valid user' do
        before { allow(controller).to receive(:current_user).and_return(user) }
        it 'add worker' do
          patch(:update_worker, id: cwork.to_param,
                                cafe_work: attributes_for(:assignee, user: user))
          cwork.reload

          cwork.has_worker?.should be_truthy
        end

        it 'update worker' do
          patch(:update_worker, id: cwork_worker.to_param,
                                cafe_work: attributes_for(:assignee, :test))
          cwork_worker.reload

          cwork_worker.worker.attributes.should include(attributes_for(:assignee, :test))
        end

        it 'assigns the requested cafe_work as @cafe_work' do
          patch(:update_worker, id: cwork.to_param, cafe_work: attributes_for(:assignee))

          assigns(:cafe_work).should eq(cwork)
        end

        it 'redirects to the cafe_work' do
          patch(:update_worker, id: cwork.to_param, cafe_work: attributes_for(:assignee))

          response.should redirect_to(cwork)
        end
      end

      context 'invalid user' do
        before do
          allow(controller).to receive(:current_user).and_return(not_owner)
        end

        it 'update worker' do
          patch(:update_worker, id: cwork_worker.to_param,
                                cafe_work: attributes_for(:assignee, :test))
          cwork_worker.reload

          cwork_worker.worker.attributes.should_not include(attributes_for(:assignee, :test))
        end

        it 'redirects to the cafe_work' do
          patch(:update_worker, id: cwork_worker.to_param, cafe_work: attributes_for(:assignee))

          response.should render_template('show')
        end
      end

      context 'with invalid params' do
        it 'assigns the cafe_work as @cafe_work' do
          patch(:update_worker, id: cwork.to_param, cafe_work: attributes_for(:assignee, :invalid))
          assigns(:cafe_work).should eq(cwork)
        end
      end
    end
  end

  describe 'PATCH #remove_worker' do
    context 'with valid user' do
      before do
        allow(controller).to receive(:current_user).and_return(user)
      end
      it 'remove worker' do
        patch(:remove_worker, id: cwork_worker.to_param)
        cwork_worker.reload

        cwork_worker.has_worker?.should be_falsey
      end

      it 'remove worker and redirect' do
        patch(:remove_worker, id: cwork_worker.to_param)
        cwork_worker.reload

        response.should redirect_to(cwork_worker)
      end

      it 'assigns the requested cafe_work as @cafe_work' do
        patch(:remove_worker, id: cwork_worker.to_param)

        assigns(:cafe_work).should eq(cwork_worker)
      end
    end

    context 'with invalid user' do
      before do
        allow(controller).to receive(:current_user).and_return(not_owner)
      end

      it 'remove worker' do
        patch(:remove_worker, id: cwork_worker.to_param)
        cwork_worker.reload

        cwork_worker.worker.present?.should be_truthy
        response.should render_template(:show)
      end
    end
  end

  describe 'GET #index' do
    it 'renders #index' do
      get(:index)
      response.should render_template(:index)
    end

    it 'assigns CafeWork.lv as @lv' do
      get(:index)
      assigns(:lv).should eq(CafeWork.get_lv)
    end

    before {
      cwork
      cwork_worker
    }

    it 'responds with JSON' do
      get(:index, start: cwork.work_day - 2.days, end: cwork.work_day + 2.days, format: :json)
      response.body.should eq([cwork.as_json, cwork_worker.as_json].to_json)
    end
  end

  describe 'GET #nyckelpiga' do
    context 'not allowed' do
      it 'does not work' do
        get(:nyckelpiga)

        # Changed the response to AccessDenied
        # response.should have_http_status(:forbidden)
        response.should redirect_to :new_user_session
      end
    end

    context 'allowed' do
      allow_user_to :nyckelpiga, CafeWork
      it 'works' do
        get(:nyckelpiga)
        response.should be_success
      end
    end
  end
end
