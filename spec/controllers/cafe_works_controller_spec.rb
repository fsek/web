require 'rails_helper'

RSpec.describe CafeWorksController, type: :controller do
  let(:user) { create(:user) }
  let(:not_owner) { create(:user) }
  let(:cwork_profile) { create(:cafe_work, :w_profile, profile: user.profile) }
  let(:cwork_access) { create(:cafe_work, :access) }
  let(:cwork) { create(:cafe_work) }

  describe 'GET #show' do
    it 'assigns the requested cafe_work as @cwork' do
      get :show, {id: cwork.to_param}
      assigns(:cwork).should eq(cwork)
    end
  end

  describe 'POST #authorize' do
    it 'authorizes with right code' do
      xhr :post, :authorize, {id: cwork_access.to_param, cafe_work: {access_code: cwork_access.access_code}}

      assigns(:cwork).should eq(cwork_access)
      assigns(:authenticated).should be_truthy
    end

    it 'authorizes with wrong code' do
      xhr :post, :authorize, {id: cwork_access.to_param, cafe_work: {access_code: 'wrong code'}}

      assigns(:authenticated).should be_falsey
    end
  end

  describe 'PATCH #update_worker' do
    context 'with valid params' do
      context 'with valid user' do
        before { sign_in user }

        it 'add worker' do
          patch :update_worker, {id: cwork.to_param, cafe_work: attributes_for(:assignee)}
          cwork.reload

          cwork.has_worker?.should be_truthy
        end

        it 'update worker' do
          patch :update_worker, {id: cwork_profile.to_param, cafe_work: attributes_for(:assignee, :test)}
          cwork_profile.reload

          cwork_profile.worker.attributes.should include(attributes_for(:assignee, :test))
        end

        it 'assigns the requested cafe_work as @cafe_work' do
          patch :update_worker, {id: cwork.to_param, cafe_work: attributes_for(:assignee)}

          assigns(:cwork).should eq(cwork)
        end

        it 'redirects to the cafe_work' do
          patch :update_worker, {id: cwork.to_param, cafe_work: attributes_for(:assignee)}

          response.should redirect_to(cwork)
        end
      end

      context 'with invalid user' do
        before { sign_in not_owner }

        it 'update worker' do
          patch :update_worker, {id: cwork_profile.to_param, cafe_work: attributes_for(:assignee, :test)}
          cwork_profile.reload

          cwork_profile.worker.attributes.should_not include(attributes_for(:assignee, :test))
        end

        it 'redirects to the cafe_work' do
          patch :update_worker, {id: cwork_profile.to_param, cafe_work: attributes_for(:assignee)}

          response.should render_template('show')
        end
      end

      context 'with no user' do
        it 'update worker' do
          patch :update_worker,
                {
                    id: cwork_access.to_param,
                    cafe_work: attributes_for(:assignee, :test, access_code: cwork_access.access_code)
                }
          cwork_access.reload

          cwork_access.worker.attributes.should include(attributes_for(:assignee, :test))
        end

        it 'redirects to the cafe_work' do
          patch :update_worker,
                {
                    id: cwork_access.to_param,
                    cafe_work: attributes_for(:assignee, access_code: cwork_access.access_code)
                }

          response.should redirect_to(cwork_access)
        end
      end
    end

    context 'with invalid params' do
      it 'assigns the cafe_work as @cafe_work' do
        patch :update_worker, {id: cwork.to_param, cafe_work: attributes_for(:assignee, :invalid)}
        assigns(:cwork).should eq(cwork)
      end

      it 're-renders the show template' do
        patch :update_worker, {id: cwork.to_param, cafe_work: attributes_for(:assignee, :invalid)}
        response.should render_template('show')
      end
    end
  end

  describe 'PATCH #remove_worker' do
    context 'with valid params' do
      context 'with valid user' do
        before { sign_in user }

        it 'remove worker with profile' do
          patch :remove_worker, {id: cwork_profile.to_param}
          cwork_profile.reload

          cwork_profile.has_worker?.should be_falsey
        end

        it 'remove worker with profile and redirect' do
          patch :remove_worker, {id: cwork_profile.to_param}
          cwork_profile.reload

          response.should redirect_to(cwork_profile)
        end

        it 'assigns the requested cafe_work as @cafe_work' do
          patch :remove_worker, {id: cwork_profile.to_param}

          assigns(:cwork).should eq(cwork_profile)
        end
      end

      context 'with invalid user' do
        before { sign_in not_owner }

        it 'remove worker' do
          patch :remove_worker, {id: cwork_profile.to_param}
          cwork_profile.reload

          cwork_profile.worker.is_present?.should be_truthy
        end

        it 'redirects to the cafe_work' do
          patch :remove_worker, {id: cwork_profile.to_param}

          response.should render_template('show')
        end
      end

      context 'with no user' do
        it 'remove worker' do
          patch :remove_worker,
                {
                    id: cwork_access.to_param,
                    cafe_work: {access_code: cwork_access.access_code}
                }
          cwork_access.reload

          cwork_access.worker.is_present?.should be_falsey
        end

        it 'redirects to the cafe_work' do
          patch :remove_worker,
                {
                    id: cwork_access.to_param,
                    cafe_work: {access_code: cwork_access.access_code}
                }

          response.should redirect_to(cwork_access)
        end
      end
    end
  end

  describe 'GET #main' do
    it 'assigns CafeWork.lv as @lv' do
      get :main
      assigns(:lv).should eq(CafeWork.get_lv)
    end
    before {
      cwork
      cwork_profile
    }
    it 'responds with JSON' do
      get :main, {start: cwork.work_day - 2.days, end: cwork.work_day + 2.days, format: :json}
      response.body.should eq([cwork.as_json,cwork_profile.as_json].to_json)
    end
  end

  describe 'GET #nyckelpiga' do
    it 'works' do
      skip('Implement when Cancancan is implemented')
    end
  end
end
