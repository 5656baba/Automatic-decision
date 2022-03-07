class ContactsController < ApplicationController
  def new
    @contact=Contact.new
  end

  def check
    @contact=Contact.new(contact_params)
  end

  def back
    @contact = Contact.new(contact_params)
    render :new
  end

  def create
    @contact=Contact.new(contact_params)
    @contact.save
    ContactMailer.send_mail(@contact).deliver_now
    redirect_to thanks_path
  end

  def thanks
  end

  private

  def contact_params
    params.require(:contact).permit(:email, :name, :message)
  end
end
