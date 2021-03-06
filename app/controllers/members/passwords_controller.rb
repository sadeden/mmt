module Members
  class PasswordsController < ApplicationController
    before_action :change_password, only: :update

    def new
      @member = current_member.decorate
    end

    def update
      if @change_password.success?
        bypass_sign_in current_member
        redirect_to member_path(current_member), notice: @change_password.message
      else
        redirect_back fallback_location: new_member_settings_password_path, alert: @change_password.message
      end
    end

    private

    def change_password
      @change_password = ChangePassword.call(
        member: current_member,
        password: current_password_params[:current_password],
        password_params: password_params
      )
    end

    def current_password_params
      params.require(:member).permit(:current_password)
    end

    def password_params
      params.require(:member).permit(:password, :password_confirmation, :authentication_code)
    end

  end
end
