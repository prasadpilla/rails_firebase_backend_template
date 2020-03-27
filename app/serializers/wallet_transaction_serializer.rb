class WalletTransactionSerializer < ActiveModel::Serializer
  attributes :id, :identifier, :description, :amount, :transaction_type, :timestamp, :closing_balance
end

