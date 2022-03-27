class User::InformationsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:show, :edit, :update, :withdraw, :unsubscribe]

  def show
    @user = current_user
  end

  def edit
    @user = current_user
  end

  def unsubscribe
  end

  def update
    @user = current_user
    if @user.update(user_params)
      redirect_to information_path(current_user)
    else
      render :edit
    end
  end

  def withdraw
    @user = current_user
    @user.update(is_active: false)
    reset_session
    flash[:notice] = "退会手続きが完了いたしました。ご利用いただき誠にありがとうございました。"
    redirect_to root_path
  end

  def ensure_correct_user
    unless user_id = current_user.id
      redirect_to root_path(current_user)
    end
  end

  private

  def user_params
    params.require(:user).permit(:last_name, :first_name, :last_name_kana, :first_name_kana, :email, :image)
  end
end
