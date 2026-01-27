class HomesController < ApplicationController
  skip_before_action :require_authentication, only: [:top, :about]

  def top
  end

  def about
  end
end
