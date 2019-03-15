class StaticPagesController < ApplicationController

  def home
    return unless logged_in?
    @micropost  = current_user.microposts.build
    @feed_items = Micropost.by_lastest.page(params[:page])
      .per Settings.quantity_per_page
  end

  def help; end

  def about; end

  def contact; end
end
