defmodule Mysqrft.Ledger do
  use Ash.Domain,
    otp_app: :mysqrft

  resources do
    resource Mysqrft.Ledger.Account
    resource Mysqrft.Ledger.Balance
    resource Mysqrft.Ledger.Transfer
  end
end
