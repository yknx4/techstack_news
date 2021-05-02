defmodule TechstackNews.News.Item do
  use Ecto.Schema
  import Ecto.Changeset
  alias TechstackNews.News.Location

  schema "items" do
    field :published_at, :naive_datetime
    field :title, :string
    field :url, :string
    field :open_graph, :map
    has_many :locations, Location

    timestamps()
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:title, :url, :published_at, :open_graph])
    |> validate_required([:title, :url, :published_at])
  end
end
