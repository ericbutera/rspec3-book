require 'sinatra/base'
require 'json'
require_relative 'ledger'

module ExpenseTracker
  class API < Sinatra::Base
    def initialize(ledger: Ledger.new) # p.66
      @ledger = ledger
      super()
    end

    post '/expenses' do
      # status 404 <-- use to break app to see if the status=200 works in api_spec p.71

      expense = JSON.parse(request.body.read)
      result = @ledger.record(expense)

      if result.success?
        JSON.generate('expense_id' => result.expense_id)
      else
        status 422
        JSON.generate('error' => result.error_message)
      end
    end

    get '/expenses/:date' do
      JSON.generate([])
    end
  end
end