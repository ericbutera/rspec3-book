require_relative '../../../app/api'
require 'rack/test'

module ExpenseTracker
  RecordResult = Struct.new(:success?, :expense_id, :error_message)

  RSpec.describe API do
    include Rack::Test::Methods

    def app
      API.new(ledger: ledger) # p.67
    end

    # creates a double "fake"; don't even need the real class to exist
    let (:ledger) { instance_double('ExpenseTracker::Ledger') } # p.67

    describe 'POST /expenses' do
      context 'when the expense is successfully recorded' do
        let(:expense) { { 'some' => 'data' } } # p.72

        before do
          allow(ledger).to receive(:record)
          .with(expense)
          .and_return(RecordResult.new(true, 417, nil))
        end

        it 'returns the expense id' do
          # expense = { 'some' => 'data' } p.72 removed in favor of let
          # allow(ledger).to receive(:record) # p.67
          #   .with(expense)
          #   .and_return(RecordResult.new(true, 417, nil))

          post '/expenses', JSON.generate(expense)
          parsed = JSON.parse(last_response.body)
          expect(parsed).to include('expense_id' => 417)
        end

        it 'responds with a 200 (OK)' do
          post '/expenses', JSON.generate(expense)
          expect(last_response.status).to eq(200)
        end
      end

      context 'when the expense fails validation' do
        it 'returns an error message'
        it 'responds with a 422 (Unprocessable entity)'
      end
    end
  end
end