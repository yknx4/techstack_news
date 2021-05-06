defmodule TechstackNews.Crawlers do
  def hacker_news do
    TechstackNews.Crawlers.HackerNews.home()
    |> Enum.map(fn i -> TechstackNews.News.upsert_item(i) end)
  end

  def rss(url) do
    url
    |> TechstackNews.Crawlers.RSS.rss()
    |> Enum.map(fn i -> TechstackNews.News.upsert_item(i) end)
  end
end
