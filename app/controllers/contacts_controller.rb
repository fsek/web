# encoding:UTF-8
class ContactsController < ApplicationController
  load_permissions_and_authorize_resource

  def index
    # @contacts initially set by Cancancan
    @councils = {}
    @councils["Styrelsen"] = []
    @councils["Övriga"] = []
    @contacts = @contacts.includes(:post).sort_by(&:to_s)
    @contacts.each do |contact|
      if contact.post.nil?
        @councils["Övriga"].push(contact)
      else
        @councils[contact.post.council.title] = [] if @councils[contact.post.council.title].nil?

        if contact.post.id == contact.post.council.president_id
          @councils[contact.post.council.title].unshift(contact)
        else
          @councils[contact.post.council.title].push(contact)
        end
      end
    end

    # Hacky shit to move 'Ovriga' to last
    # This whole thing should have a proper sort method
    # But too much effort for too little gain for me atm
    misc = @councils["Övriga"]
    @councils = @councils.except("Övriga")
    @councils["Övriga"] = misc
  end

  def show
    @contact = Contact.find(params[:id])
    @contact.message = ContactMessage.new
  end

  def mail
    @contact = Contact.find(params[:id])
    @contact.message ||= ContactMessage.new(message_params)
    if verify_recaptcha(model: @contact, attribute: :recaptcha) && @contact.send_email
      redirect_to contact_path(@contact), notice: t("model.contact.message_sent")
    else
      flash[:alert] = t("model.contact.something_wrong")
      render :show, status: 422
    end
  end

  private

  def message_params
    params.require(:contact_message).permit(:name, :email, :message)
  end
end
