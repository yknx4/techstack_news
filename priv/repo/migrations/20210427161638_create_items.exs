defmodule TechstackNews.Repo.Migrations.CreateItems do
  use Ecto.Migration

  def change do
    create table(:items) do
      add :title, :string
      add :url, :string
      add :published_at, :naive_datetime
      add :open_graph, :jsonb

      timestamps()
    end

    create unique_index(:items, [:url])
  end
end
