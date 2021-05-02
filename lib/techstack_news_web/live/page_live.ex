defmodule TechstackNewsWeb.PageLive do
  use TechstackNewsWeb, :live_view
  alias TechstackNews.News
  alias TechstackNews.Repo

  @impl true
  def mount(params, _session, socket) do
    after_cursor = Map.get(params, "after")
    before_cursor = Map.get(params, "before")

    items = News.list_items(after: after_cursor, before: before_cursor)
    IO.inspect(params)

    {:ok,
     assign(socket,
       results: items.entries |> Repo.preload([:locations]),
       pagination: items.metadata
     )}
  end
end
