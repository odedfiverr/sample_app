class UsersController < ApplicationController
	
  before_action :signed_in_user, only: [:index, :edit, :update]
  before_action :correct_user,   only: [:edit, :update]
  before_action :no_self_delete, only: :destroy
  before_action :admin_user,     only: :destroy
  before_action :redirect_signed, only: [:new, :create ]

  def index
  	@users = User.paginate(page: params[:page])
  end

  def new
  	@user = User.new
  end

  def create
    @user = User.new(user_params)    # Not the final implementation!
    if @user.save
    	sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to user_path(@user)
    else
      render 'new'
    end
  end

  def destroy
  	@user = User.find(params[:id])
  	@user.destroy
  	flash[:success] = "User deleted"
  	redirect_to users_path
  end

  def edit
    @user = User.find(params[:id])
  end

  def show
  	@user = User.find_by(id: params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
     flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

   private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end

	def no_self_delete
		@user = User.find(params[:id])
		puts "#{@user.id} : #{current_user.id}"
		redirect_to(root_url) unless !current_user?(@user)
	end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

    def redirect_signed 
    	if signed_in?
    	  redirect_to(root_url)
    	end
    end
end
