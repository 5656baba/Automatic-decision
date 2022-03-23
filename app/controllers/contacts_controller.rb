class ContactsController < ApplicationController
  def new
    @contact=Contact.new
  end

  def check
    @contact=Contact.new(contact_params)
    if params[:contact][:name] == "" && params[:contact][:email] != "" && params[:contact][:message] != ""
      flash.now[:notice] = "お名前を入力してください"
      @contact = Contact.new(contact_params)
      render :new
    elsif params[:contact][:email] == "" && params[:contact][:name] != "" && params[:contact][:message] != ""
      flash.now[:notice] = "メールアドレスを入力してください"
      @contact = Contact.new(contact_params)
      render :new
    elsif params[:contact][:message] == "" && params[:contact][:name] != "" && params[:contact][:email] != ""
      flash.now[:notice] = "お問合せ内容を入力してください"
      @contact = Contact.new(contact_params)
      render :new
    elsif params[:contact][:name] == "" || params[:contact][:email] == "" || params[:contact][:message] == ""
      flash.now[:notice] = "情報を全て入力してください"
      @contact = Contact.new(contact_params)
      render :new
    end
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
