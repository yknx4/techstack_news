defmodule TechstackNews.OpenGraph do
  use Tesla

  plug Tesla.Middleware.Logger, debug: false
  plug Tesla.Middleware.Compression, format: "gzip"
  plug Tesla.Middleware.FollowRedirects

  def fetch(url) do
    get(url)
    |> parse()
  end

  def parse({:ok, %Tesla.Env{body: html}}) do
    {:ok, OpenGraph.parse(html)}
  end

  def parse(i), do: i
end
