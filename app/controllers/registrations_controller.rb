class RegistrationsController < ApplicationController

  before_action :set_registration, only: [:show, :edit, :update, :destroy]

  def new
    @registration = Registration.new
    @registration.build_card
    @order = Order.find_by id: params["order_id"]
  end

	def create
    @registration = Registration.new(registration_params)
    @registration.card.ip_address = request.remote_ip
    if @registration.save
      case params['payment_method']
        when "paypal"
          redirect_to @registration.paypal_url(registration_path(@registration))
        when "card"
          if @registration.card.purchase
            redirect_to registration_path(@registration), notice: @registration.card.card_transaction.message
          else
            redirect_to registration_path(@registration), alert: @registration.card.card_transaction.message
          end
      end
    else
      render :new
    end
  end

  def show
  end

  protect_from_forgery except: [:hook]
  
  def hook
    params.permit! # Permit all Paypal input params
    status = params[:payment_status]
    if status == "Completed"
      @registration = Registration.find params[:invoice]
      @registration.update_attributes notification_params: params, status: status, transaction_id: params[:txn_id], purchased_at: Time.now
    end
    render nothing: true
  end

  private

  def set_registration
    @registration = Registration.find(params[:id])
  end

  def registration_params
    params.require(:registration).permit(:order_id,:full_name, :company, :email, :telephone, :quantity,
                                          card_attributes: [
                                              :first_name, :last_name, :card_type, :card_number,
                                              :card_verification, :card_expires_on])
  end


end
