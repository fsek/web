class WorkPortal
  attr_reader(:current, :current_post, :work_posts,
              :grid, :companies, :target_groups,
              :fields, :kinds)

  def initialize(current_post: nil, work_posts: [], grid: nil)
    @current = {}
    @companies = WorkPost.companies
    @current_post = current_post
    @fields = WorkPost.fields
    @grid = grid
    @kinds = WorkPost.kinds
    @target_groups = WorkPost.target_groups
    @work_posts = work_posts
  end

  def current_and_filter(filtering_params)
    # Uses model scopes and filtering_params is defined in controller
    # key = scope, value = value from param
    filtering_params.each do |key, value|
      if value.present?
        @work_posts = @work_posts.public_send(key, value)
        @current[key.to_sym] = value
      end
    end
  end

  def new_target_path(target)
    Rails.application.routes.url_helpers.
      work_posts_path(target: target,
                      field: @current[:field],
                      kind: @current[:kind])
  end

  def new_field_path(field)
    Rails.application.routes.url_helpers.
      work_posts_path(target: @current[:target],
                      field: field,
                      kind: @current[:kind])
  end

  def new_kind_path(kind)
    Rails.application.routes.url_helpers.
      work_posts_path(target: @current[:target],
                      field: @current[:field],
                      kind: kind)
  end
end
