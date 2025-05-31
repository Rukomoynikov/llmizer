defmodule Llmizer.Repo do
  use Ecto.Repo,
    otp_app: :llmizer,
    adapter: Ecto.Adapters.SQLite3
end
