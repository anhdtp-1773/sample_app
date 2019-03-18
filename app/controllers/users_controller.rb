class UsersController < ApplicationController
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: %i(destroy)
  before_action :load_user, except: %i(new create index)
  before_action :logged_in_user, except: %i(new create show)

  def index
    @users = User.page(params[:page]).per Settings.quantity_per_page
  end

  def new
    @user = User.new
  end

  def show
    @microposts = @user.microposts.page(params[:page])
      .per Settings.quantity_per_page
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t(".please_check_your_email_to_activate_your_account")
      redirect_to root_url
    else
      render :new
    end
  end

  def edit; end

  def update
     if @user.update user_params
      flash[:success] = t(".profile_updated")
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t(".user_delete_succeed")
    else
      flash[:error] = t(".user_delete_failed")
    end
    redirect_to users_url
  end

  def following
    @title = t(".following")
    @users = @user.following.page(params[:page]).per Settings.quantity_per_page
    render "show_follow"
  end

  def followers
    @title = t(".followers")
    @users = @user.followers.page(params[:page]).per Settings.quantity_per_page
    render "show_follow"
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end

  def correct_user
    @user = User.find_by id: params[:id]
    redirect_to(root_url) unless current_user?(@user)
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user
    flash[:error] = t(".user_not_found")
    redirect_to root_path
  end
end
