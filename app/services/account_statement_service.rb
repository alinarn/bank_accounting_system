class AccountStatementService
  attr_accessor :user_id, :currency, :start_date, :end_date

  def initialize(params)
    @user_id = params[:user_id]
    @currency = params[:currency]
    @start_date = params[:start_date]
    @end_date = params[:end_date]
  end

  def create_statement(statement_type)
    case statement_type
    when "deposit"
      create_deposit_statement
    end
  end

  private

    def create_deposit_statement
      account = Account.find_by(user_id: user_id, currency: currency)
      transactions = Transaction.all
                    .where(account_id: account.id, status: :deposited)
                    .filter_by_date(start_date, end_date)                     
      print_statement(account, transactions)
    end

    def print_statement(account, transactions)
     statement = transactions.map do |record|
       <<~EOM
         #{record.created_at.to_formatted_s(:long)} - #{record.amount} (#{account.currency})
         ***
       EOM
     end
     puts "User id - #{account.user_id}, account statement:"
     puts statement
   end
end