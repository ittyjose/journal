# frozen_string_literal: true

class Api::V1::UsersController < Api::V1::BaseController
  skip_before_action :authenticate_user_using_x_auth_token!, only: [:verify_otp]

  def verify_otp
    @user = User.find(params[:id])
    if @user.valid_otp?(params[:otp])
      render json: @user
    else
      head :bad_request
    end
  end

  def show
    @user.id
  end
end
