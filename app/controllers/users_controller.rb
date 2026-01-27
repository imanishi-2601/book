class UsersController < ApplicationController
  # 認証をスキップ: サインアップ（new, create）はログイン前に行うため
  allow_unauthenticated_access only: [:new, :create]

  def index
    @user  = Current.session.user   # 左（自分）
    @book  = Book.new               # 左（New book）
    @users = User.all               # 右（ユーザー一覧）
  end

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

  # ✅ 自分の編集画面だけ表示（URLの:idに依存しない）
  def edit
    @user = Current.session.user
  end

  # ✅ 自分だけ更新（URLの:idに依存しない）
  def update
    @user = Current.session.user

    if @user.update(user_params)
      redirect_to user_path(@user), notice: "ユーザー情報を更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  # ✅ user_paramsは1つだけに統一（avatarも許可するならここに残す）
  def user_params
    params.require(:user).permit(:name, :email_address, :password, :password_confirmation, :avatar)
  end
end
