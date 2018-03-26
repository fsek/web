class Api::ContactsController < Api::BaseController
  load_permissions_and_authorize_resource

  def index
    # We need ruby sorting here due to dynamic naming
    @contacts = @contacts.includes(:post).sort_by(&:to_s)
    render json: @contacts, each_serializer: Api::ContactsSerializer::Index
  end

  def show
    @contact = Contact.find(params[:id])
    render json: @contact, serializer: Api::ContactsSerializer::Show
  end

  def mail
    @contact = Contact.find(params[:id])
    @contact.message ||= ContactMessage.new(message_params)
    if @contact.send_email
      render json: {}, status: :ok
    else
      render json: { errors: @contact.errors.full_messages }, status: 422
    end
  end

  private

  def message_params
    params.require(:contact_message).permit(:name, :email, :message)
  end
end
