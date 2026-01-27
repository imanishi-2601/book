class BooksController < ApplicationController
  def create
    @book = Book.new(book_params)
    # もし user と紐付けるなら（推奨）
    @book.user = Current.session.user

    if @book.save
      redirect_to user_path(@book.user), notice: "Book created!"
    else
      @user = Current.session.user
      render "users/show", status: :unprocessable_entity
    end
  end

  private

  def book_params
    params.require(:book).permit(:title, :body)
  end
end