class Admin::ContactsController < Admin::BaseController
  load_permissions_and_authorize_resource

  def index
    @contact_grid = initialize_grid(Contact, include: :post)
  end

  def new
    @contact = Contact.new
    @posts = Post.by_title
  end

  def edit
    @contact = Contact.find(params[:id])
    @posts = Post.by_title
  end

  def create
    @contact = Contact.new(contact_params)
    @posts = Post.by_title
    if @contact.save
      if params[:contact][:avatar].present?
        render :crop
      else
        redirect_to edit_admin_contact_path(@contact), notice: alert_create(Contact)
      end
    else
      render :new, status: 422
    end
  end

  def update
    @contact = Contact.find(params[:id])
    @posts = Post.by_title
    if @contact.update(contact_params)
      if params[:contact][:avatar].present?
        render :crop
      else
        redirect_to edit_admin_contact_path(@contact), notice: alert_update(Contact)
      end
    else
      render :edit, status: 422
    end
  end

  def destroy
    @contact = Contact.find(params[:id])
    @contact.destroy!
    redirect_to admin_contacts_path, notice: alert_destroy(Contact)
  end

  private

  def contact_params
    params.require(:contact).permit(:name_sv, :name_en, :email, :public, :avatar,
                                    :text_sv, :text_en, :post_id, :slug, :remove_avatar,
                                    :crop_x, :crop_y, :crop_w, :crop_h)
  end
end
