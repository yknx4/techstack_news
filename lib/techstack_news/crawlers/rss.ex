defmodule TechstackNews.Crawlers.RSS do
  use Tesla
  alias TechstackNews.OpenGraph

  plug Tesla.Middleware.Logger, debug: false
  plug Tesla.Middleware.Compression, format: "gzip"

  def rss(url) do
    get(url)
    |> parse()
    |> enrich()
  end

  def parse({:ok, %Tesla.Env{url: url, body: html}}) do
    NodeJS.call({"techstack-news-crawler", :RssParser}, [html, url])
  end

  def parse(i), do: i

  def enrich({:ok, items}) do
    items |> Enum.map(&enrich/1)
  end

  def enrich(%{"url" => url} = base) do
    with {:ok, og} <- OpenGraph.fetch(url) do
      base |> Map.merge(%{"open_graph" => og |> Map.from_struct()})
    else
      _ -> base |> Map.merge(%{"open_graph" => %{}})
    end
  end

  def enrich(i), do: i
end
