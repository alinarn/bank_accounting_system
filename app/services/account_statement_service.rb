class AccountStatementService
  attr_accessor :user_id, :currency, :start_date, :end_date, :tag

  def initialize(params)
    @user_id = params[:user_id]
    @currency = params[:currency]
    @start_date = params[:start_date]
    @end_date = params[:end_date]
    @tag = params[:tag]
  end

  def create_statement(statement_type)
    case statement_type
    when "deposit"
      create_deposit_statement
    when "min_avg_max"
      create_min_avg_max_statement  
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

    def create_min_avg_max_statement
      query = Transaction.joins(account: { user: :tags })
              .where(tags: { tag: tag })
              .where(status: "received", created_at: start_date..end_date)

      minimum = query.minimum(:amount)
      average = query.average(:amount)
      maximum = query.maximum(:amount)

      print_min_avg_max_statement(minimum, average, maximum)     
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

   def print_min_avg_max_statement(min, avg, max)
     puts <<~EOM
      Minimum, maximum and average transfered amount filtered by user tag: "#{tag}" in a given time
      (#{start_date} - #{end_date})
      minimum amount -- #{min}
      maximum amount -- #{max}
      average amount -- #{avg} 
    EOM
   end
end