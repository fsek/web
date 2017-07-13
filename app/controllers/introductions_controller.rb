class IntroductionsController < ApplicationController
  before_action :set_introduction, only: [:index, :matrix, :dance]
  load_permissions_then_authorize_resource(find_by: :slug)

  def index
    @news = News.for_feed.slug(:nollning).limit(5)
    @contact = Contact.find_by(slug: 'foset')
  end

  def dance
    @constant = Constant.find_by_name('nollning-video')
  end

  def show
    @introduction = Introduction.find_by_slug!(params[:id])
    set_meta_tags(no_index: true)
    render :index
  end

  def archive
    @introductions = Introduction.by_start
  end

  def matrix
    param = params.fetch(:hide, nil)
    cookie = cookies[:hide_matrix]

    if param.present? && param != cookie
      cookies[:hide_matrix] = { value: param, expires_in: 20.days.from_now }
      flash[:notice] = I18n.t('model.introduction.matrix.hidden') if param == 'true'
      flash[:notice] ||= I18n.t('model.introduction.matrix.shown')
    end
  end

  def modal
    @introduction = Introduction.find_by_slug!(params[:id])
    @date = date
    @events = @introduction.events(locale: I18n.locale).from_date(@date)
    respond_to do |format|
      format.html { render :matrix, status: 303 }
      format.js
    end
  end

  private

  def set_introduction
    @introduction = Introduction.current

    if @introduction.nil?
      @introductions = Introduction.by_start
      render :archive, status: 404
    end
  end

  def date
    begin
      Date.strptime(%({#{params[:date]}}), '{%Y-%m-%d}')
    rescue
      Date.today
    end
  end
end
