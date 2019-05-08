class Admin::ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin!

  def show
  end

  def edit
  end

  def update
    if current_user.update(admin_params)
      redirect_to admin_profile_path, notice: 'Your profile was successfully updated.'
    else
      render :edit
    end
  end
  
  private
  
  def admin_params
    params.require(:user).permit(
      :first_name, :last_name, :region_id
    )
  end
end
