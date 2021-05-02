defmodule TechstackNews.Repo.Migrations.CreateLocations do
  use Ecto.Migration

  def change do
    create table(:locations) do
      add :domain, :string
      add :item_id, references(:items, on_delete: :nothing)

      timestamps()
    end

    create index(:locations, [:item_id])
    create unique_index(:locations, [:item_id, :domain])
  end
end
