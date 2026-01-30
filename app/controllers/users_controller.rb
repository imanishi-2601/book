class UsersController < ApplicationController
  # サインアップ（new, create）はログイン前に行うため
  allow_unauthenticated_access only: [:new, :create]

  before_action :set_user, only: [:show]
  before_action :ensure_correct_user, only: [:edit, :update]

  def index
    @user  = Current.session.user   # 左（自分）
    @new_book  = Book.new               # 左（New book）
    @users = User.all               # 右（ユーザー一覧）
  end

  def new
    @user = User.new
  end

  def show
    @user     = User.find(params[:id])
    @new_book = Book.new
    @books    = @user.books
  end

  def create
    @user = User.new(user_params)

    if @user.save
      start_new_session_for(@user)  # 自動ログイン
      redirect_to user_path(@user), notice: "Welcome! You have signed up successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @user = Current.session.user
  end

  def update
    @user = Current.session.user

    if @user.update(user_params)
      redirect_to user_path(@user), notice: "You have updated user successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def ensure_correct_user
    return if params[:id].to_s == Current.session.user.id.to_s
    redirect_to user_path(Current.session.user)
  end

  def user_params
    params.require(:user).permit(
      :name,
      :introduction,
      :email_address,
      :password,
      :password_confirmation,
      :profile_image,
    )
  end
end