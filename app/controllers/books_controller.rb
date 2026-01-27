class BooksController < ApplicationController
  before_action :set_book, only: [:show, :edit, :destroy]
  def create
    @book = Book.new(book_params)
    # もし user と紐付けるなら（推奨）
    @book.user = Current.session.user

    if @book.save
      redirect_to book_path(@book), notice: "Book was successfully created."
    else
      @user = Current.session.user
      @books = Book.includes(:user).all
      render :index, status: :unprocessable_entity
    end
  end

  def index
    @user  = Current.session.user   # 左：User info（自分）
    @book  = Book.new               # 左：New bookフォーム
    @books = Book.includes(:user).all  # 右：Books一覧（必要なら user も取る）
  end

  def show
    @book = Book.find(params[:id])

    # 左側「User info」の表示用（本の投稿者 or 自分、indexと揃えてどちらかに統一）
    @user = @book.user   # ← Bookが user に紐づいている前提（belongs_to :user）

    # 左側「New book」フォーム用（indexと同じく新規投稿を置く）
    @new_book = Book.new
  end

  def edit
    @book = Book.find(params[:id])
  end

  def destroy
    @book.destroy
    redirect_to books_path, notice: "Book deleted!"
  end

  private

  def set_book
    @book = Book.find(params[:id])
  end

  def require_owner!
    unless authenticated? && @book.user == current_user
      redirect_to books_path, alert: "権限がありません"
    end
  end

  def book_params
    params.require(:book).permit(:title, :body)
  end
end