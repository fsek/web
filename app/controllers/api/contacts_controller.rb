class Api::ContactsController < Api::BaseController
  # Special auth due to api using this controller.
  # We do not want to expose emails and such.
  before_action :load_permissions

  def index
    authorize!(:index, :contact)

    # We need ruby sorting here due to dynamic naming
    @contacts = Contact.includes(:post).sort_by(&:to_s)
    render json: @contacts, each_serializer: Api::ContactsSerializer::Index
  end

  def show
    authorize!(:show, :contact)

    @contact = Contact.find(params[:id])
    render json: @contact, serializer: Api::ContactsSerializer::Show
  end

  def mail
    authorize!(:mail, :contact)

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
