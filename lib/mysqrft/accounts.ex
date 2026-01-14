defmodule Mysqrft.Accounts do
  use Ash.Domain, otp_app: :mysqrft, extensions: [AshAdmin.Domain]

  admin do
    show? true
  end

  resources do
    resource Mysqrft.Accounts.Token
    resource Mysqrft.Accounts.User
  end
end
