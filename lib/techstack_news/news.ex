defmodule TechstackNews.News do
  @moduledoc """
  The News context.
  """

  import Ecto.Query, warn: false
  alias TechstackNews.Repo

  alias TechstackNews.News.Item

  @doc """
  Returns the list of items.

  ## Examples

      iex> list_items()
      [%Item{}, ...]

  """
  def list_items(opts \\ []) do
    cursor_after = Keyword.get(opts, :after)
    cursor_before = Keyword.get(opts, :before)

    query = from(i in Item, order_by: [desc: i.published_at, desc: i.id])
    cursor_fields = [{:published_at, :desc}, {:id, :desc}]

    cond do
      !is_nil(cursor_after) ->
        query |> Repo.paginate(after: cursor_after, cursor_fields: cursor_fields, limit: 9)

      !is_nil(cursor_before) ->
        query
        |> Repo.paginate(before: cursor_before, cursor_fields: cursor_fields, limit: 9)

      true ->
        query |> Repo.paginate(cursor_fields: cursor_fields, limit: 9)
    end
  end

  @doc """
  Gets a single item.

  Raises `Ecto.NoResultsError` if the Item does not exist.

  ## Examples

      iex> get_item!(123)
      %Item{}

      iex> get_item!(456)
      ** (Ecto.NoResultsError)

  """
  def get_item!(id), do: Repo.get!(Item, id)

  def get_item(:url, nil), do: nil

  def get_item(:url, url) do
    from(i in Item, where: i.url == ^url) |> Repo.one()
  end

  @doc """
  Creates a item.

  ## Examples

      iex> create_item(%{field: value})
      {:ok, %Item{}}

      iex> create_item(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_item(attrs \\ %{}) do
    %Item{}
    |> Item.changeset(attrs)
    |> Repo.insert()
  end

  def upsert_item(%{
        "open_graph" => open_graph,
        "createdAt" => published_at,
        "foundAt" => domain,
        "title" => parsed_title,
        "url" => parsed_url
      }) do
    url = Map.get(open_graph, :url, parsed_url)
    title = Map.get(open_graph, :title, parsed_title)

    db_item = get_item(:url, url)

    db_item =
      if(is_nil(db_item),
        do:
          create_item(%{
            url: url,
            title: title,
            published_at: published_at,
            open_graph: open_graph
          }),
        else: {:ok, db_item}
      )

    with {:ok, item} <- db_item,
         {:ok, item} <- item |> update_open_graph(open_graph) do
      location = create_location(%{domain: domain}, item)
      {:ok, item, location}
    end
  end

  defp update_open_graph(%Item{open_graph: open_graph} = i, og) when open_graph == %{} do
    i
    |> Item.changeset(%{open_graph: og})
    |> Repo.update()
  end

  defp update_open_graph(i, _), do: {:ok, i}

  @doc """
  Updates a item.

  ## Examples

      iex> update_item(item, %{field: new_value})
      {:ok, %Item{}}

      iex> update_item(item, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_item(%Item{} = item, attrs) do
    item
    |> Item.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a item.

  ## Examples

      iex> delete_item(item)
      {:ok, %Item{}}

      iex> delete_item(item)
      {:error, %Ecto.Changeset{}}

  """
  def delete_item(%Item{} = item) do
    Repo.delete(item)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking item changes.

  ## Examples

      iex> change_item(item)
      %Ecto.Changeset{data: %Item{}}

  """
  def change_item(%Item{} = item, attrs \\ %{}) do
    Item.changeset(item, attrs)
  end

  alias TechstackNews.News.Location

  @doc """
  Returns the list of locations.

  ## Examples

      iex> list_locations()
      [%Location{}, ...]

  """
  def list_locations do
    Repo.all(Location)
  end

  @doc """
  Gets a single location.

  Raises `Ecto.NoResultsError` if the Location does not exist.

  ## Examples

      iex> get_location!(123)
      %Location{}

      iex> get_location!(456)
      ** (Ecto.NoResultsError)

  """
  def get_location!(id), do: Repo.get!(Location, id)

  @doc """
  Creates a location.

  ## Examples

      iex> create_location(%{field: value})
      {:ok, %Location{}}

      iex> create_location(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_location(attrs \\ %{}, item) do
    %Location{}
    |> Location.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:item, item)
    |> Repo.insert()
  end

  @doc """
  Updates a location.

  ## Examples

      iex> update_location(location, %{field: new_value})
      {:ok, %Location{}}

      iex> update_location(location, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_location(%Location{} = location, attrs) do
    location
    |> Location.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a location.

  ## Examples

      iex> delete_location(location)
      {:ok, %Location{}}

      iex> delete_location(location)
      {:error, %Ecto.Changeset{}}

  """
  def delete_location(%Location{} = location) do
    Repo.delete(location)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking location changes.

  ## Examples

      iex> change_location(location)
      %Ecto.Changeset{data: %Location{}}

  """
  def change_location(%Location{} = location, attrs \\ %{}) do
    Location.changeset(location, attrs)
  end
end
