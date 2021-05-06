# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :techstack_news,
  ecto_repos: [TechstackNews.Repo]

# Configures the endpoint
config :techstack_news, TechstackNewsWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "gOqflccL7qxMbC/MkiUCtvhAKr4lS92D45FeCLc8ne2CLGXI3Mh6lPl6Ev2v3OdN",
  render_errors: [view: TechstackNewsWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: TechstackNews.PubSub,
  live_view: [signing_salt: "Tpgfjv/K"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason
config :tesla, adapter: Tesla.Adapter.Hackney

config :techstack_news, TechstackNews.Scheduler,
  jobs: [
    {"*/15 * * * *", {TechstackNews.Crawlers, :hacker_news, []}},
    {"*/30 * * * *",
     {TechstackNews.Crawlers, :rss, ["https://www.reddit.com/r/programming/.rss"]}},
    {"*/30 * * * *", {TechstackNews.Crawlers, :rss, ["https://www.androidpolice.com/feed/"]}},
    {"*/30 * * * *", {TechstackNews.Crawlers, :rss, ["https://www.xda-developers.com/feed/"]}},
    {"*/30 * * * *", {TechstackNews.Crawlers, :rss, ["https://arstechnica.com/feed/"]}},
    {"*/30 * * * *", {TechstackNews.Crawlers, :rss, ["https://www.engadget.com/rss.xml"]}}
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
