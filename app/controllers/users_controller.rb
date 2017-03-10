class UsersController < ApplicationController

  def edit
    @user = current_team.users.find_by(id: params[:id])
    if current_user != @user
      redirect_to "/users/#{current_user.id}/edit"
    else
      render :edit
    end
  end

  def show
    @user = current_team.users.find(params[:id])
  end

  def update
    @user = current_team.users.infd_by(id: params[:id])
    if @user && @user.update_attributes(valid_params(params[:user]))
      redirect_to "/members/#{current_user.user_name}", notice: 'Password was updated'
    else
      render :edit
    end
  end

  private

  def valid_params(inputs)
    inputs.permit(:password, :password_confirmation)
  end

end
