defmodule TechstackNewsWeb.ItemController do
  use TechstackNewsWeb, :controller

  alias TechstackNews.News
  alias TechstackNews.News.Item
  alias TechstackNews.Repo

  def index(conn, params) do
    after_cursor = Map.get(params, "after")
    before_cursor = Map.get(params, "before")

    items = News.list_items(after: after_cursor, before: before_cursor)

    render(conn, "index.html",
      results: items.entries |> Repo.preload([:locations]),
      pagination: items.metadata
    )
  end

  def new(conn, _params) do
    changeset = News.change_item(%Item{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"item" => item_params}) do
    case News.create_item(item_params) do
      {:ok, item} ->
        conn
        |> put_flash(:info, "Item created successfully.")
        |> redirect(to: Routes.item_path(conn, :show, item))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    item = News.get_item!(id)
    render(conn, "show.html", item: item)
  end

  def edit(conn, %{"id" => id}) do
    item = News.get_item!(id)
    changeset = News.change_item(item)
    render(conn, "edit.html", item: item, changeset: changeset)
  end

  def update(conn, %{"id" => id, "item" => item_params}) do
    item = News.get_item!(id)

    case News.update_item(item, item_params) do
      {:ok, item} ->
        conn
        |> put_flash(:info, "Item updated successfully.")
        |> redirect(to: Routes.item_path(conn, :show, item))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", item: item, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    item = News.get_item!(id)
    {:ok, _item} = News.delete_item(item)

    conn
    |> put_flash(:info, "Item deleted successfully.")
    |> redirect(to: Routes.item_path(conn, :index))
  end
end
