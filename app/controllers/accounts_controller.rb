class AccountsController < ApplicationController

  def create
    account = Account.new(account_params)

    if account.save
      render json: account, status: :created
    else
      render json: account.errors, status: :unprocessable_entity
    end
  end

  def deposit
    account = set_account(params[:user_id])

    if Account.deposit(account, params[:amount].to_d)
      render json: account, status: :ok
    else
      return head :unprocessable_entity
    end
  end

  def transfer
    account = Account.find_by(currency: params[:currency], user_id: params[:user_id])
    return head :not_found unless account

    recipient_account = set_account(params[:recipient_id])

    if Account.transfer(account, recipient_account, params[:amount].to_d)
      render json: { transfered: true }
    else
      return head :unprocessable_entity
    end
  end

  private

  def account_params
    params.permit(:currency, :user_id, :amount, :recipient_id)
  end

  def set_account(user_id)
    account = Account.find_by(currency: params[:currency], user_id: user_id)
    if account.nil?
      user = User.find(user_id)
      account = user.accounts.build(currency: params[:currency])
    else
      account
    end
  end
end