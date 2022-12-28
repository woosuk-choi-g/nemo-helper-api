defmodule NemoHelper.Repo do
  use Ecto.Repo,
    otp_app: :nemo_helper,
    adapter: Ecto.Adapters.MyXQL
end
