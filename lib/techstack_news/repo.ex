defmodule TechstackNews.Repo do
  use Ecto.Repo,
    otp_app: :techstack_news,
    adapter: Ecto.Adapters.Postgres

  use Paginator
end
