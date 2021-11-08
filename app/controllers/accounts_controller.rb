class AccountsController < ApplicationController

  def create
    account = Account.new(account_params)

    if account.save
      render json: account, status: :ok
    else
      render json: account.errors, status: :unprocessable_entity
    end
  end

  def deposit
    account = set_account
    if Account.deposit(account, params[:amount].to_d)
      render json: account, status: :ok
    else
      render json: account.errors, status: :unprocessable_entity
    end
  end

  private

  def account_params
    params.require(:account).permit(:currency, :user_id, :amount)
  end

  def set_account
    account = Account.find_by(currency: params[:currency], user_id: params[:user_id])
    if account.nil?
      user = User.find(params[:user_id])
      account = user.accounts.build(currency: params[:currency])
    else
      account
    end
  end
end