require 'rails_helper'

RSpec.describe WorkPortal do
  describe 'published' do
    it 'gives only published' do
      create(:work_post, publish: 5.days.from_now, title: 'First')
      create(:work_post, publish: 5.days.ago, title: 'Second')
      create(:work_post, publish: 5.days.ago, title: 'Third')
      portal = WorkPortal.new(work_posts: WorkPost.published)

      portal.work_posts.map(&:title).should eq(['Second', 'Third'])
    end
  end

  describe 'target_groups' do
    it 'gives target_groups' do
      create(:work_post, target_group: 'Teknisk fysik')
      create(:work_post, target_group: 'Teknisk fysik')
      create(:work_post, target_group: 'Teknisk matematik')
      portal = WorkPortal.new(work_posts: WorkPost.published)

      portal.target_groups.should eq(['Teknisk fysik', 'Teknisk matematik'])
    end
  end

  describe 'fields' do
    it 'gives fields' do
      create(:work_post, field: 'IT')
      create(:work_post, field: 'IT')
      create(:work_post, field: 'Ekonomi')
      portal = WorkPortal.new(work_posts: WorkPost.published)

      portal.fields.should eq(['Ekonomi', 'IT'])
    end
  end

  describe 'kinds' do
    it 'gives kinds' do
      create(:work_post, kind: 'Sommarjobb')
      create(:work_post, kind: 'Sommarjobb')
      create(:work_post, kind: 'Deltid')
      portal = WorkPortal.new(work_posts: WorkPost.published)

      portal.kinds.should eq(['Deltid', 'Sommarjobb'])
    end
  end

  describe '#current_and_filter' do
    it 'sets current and filters' do
      filter_params = {}
      filter_params[:target] = 'Teknisk fysik'
      filter_params[:field] = 'IT'
      filter_params[:kind] = 'Deltid'

      create(:work_post, title: 'Hidden target', target_group: 'Teknisk matematik',
                         field: 'IT', kind: 'Deltid')
      create(:work_post, title: 'Hidden field', target_group: 'Teknisk fysik',
                         field: 'Ekonomi', kind: 'Deltid')
      create(:work_post, title: 'Hidden kind', target_group: 'Teknisk fysik',
                         field: 'IT', kind: 'Sommarjobb')
      create(:work_post, title: 'Showing', target_group: 'Teknisk fysik',
                         field: 'IT', kind: 'Deltid')

      portal = WorkPortal.new(work_posts: WorkPost.published)
      portal.work_posts.map(&:title).should eq(['Hidden target',
                                                'Hidden field',
                                                'Hidden kind',
                                                'Showing'])
      portal.current_and_filter(filter_params)

      portal.work_posts.map(&:title).should eq(['Showing'])
    end
  end
end
