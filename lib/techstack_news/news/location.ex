defmodule TechstackNews.News.Location do
  use Ecto.Schema
  import Ecto.Changeset
  alias TechstackNews.News.Item

  schema "locations" do
    field :domain, :string
    belongs_to :item, Item

    timestamps()
  end

  @doc false
  def changeset(location, attrs) do
    location
    |> cast(attrs, [:domain])
    |> validate_required([:domain])
    |> unique_constraint([:item_id, :domain])
  end
end
