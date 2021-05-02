defmodule TechstackNews.Repo.Migrations.AddPaginationIndex do
  use Ecto.Migration

  def change do
    create index("items", [:published_at, :id])
  end
end
