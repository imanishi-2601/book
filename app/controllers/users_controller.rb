class UsersController < ApplicationController
  # 認証をスキップ: サインアップ（new, create）はログイン前に行うため
  allow_unauthenticated_access only: [:new, :create]

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
    @book = Book.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      # ユーザー登録成功後、ログイン画面へリダイレクト
      redirect_to new_session_path, notice: "ユーザー登録が完了しました！続けてログインしてください。"
    else
      # エラー時はフォームを再表示
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @user = User.find(params[:id])

    # 他人の更新を防ぐ（重要）
    unless @user == Current.session.user
      redirect_to root_path, alert: "権限がありません"
      return
    end

    if @user.update(user_params)
      redirect_to user_path(@user), notice: "画像を更新しました"
    else
      @book = Book.new
      render :show, status: :unprocessable_entity
    end
  end

  def user_params
    params.require(:user).permit(:name, :email_address, :password, :password_confirmation, :avatar)
  end

  private

  def user_params
    # name, email_address, password, password_confirmation を許可
    params.require(:user).permit(:name, :email_address, :password, :password_confirmation)
  end
end