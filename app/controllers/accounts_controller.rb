class AccountsController < ApplicationController

  def create
    account = Account.new(account_params)

    if account.save
      render json: account, status: :ok
    else
      render json: account.errors, status: :unprocessable_entity
    end
  end

  private

  def account_params
    params.require(:account).permit(:currency, :user_id)
  end
end