class UsersController < ApplicationController
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

  def show
  	@user = User.find_by(id: params[:id])
  end

   private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
end
