# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :cookbook,
  ecto_repos: [Cookbook.Repo]

# Configures the endpoint
config :cookbook, CookbookWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "dZjvkOJadDY+ntb5d9SMAir3/u6f0Unw1wfH4gsevy2rWXj9aTKvD/nHHtpGT7/R",
  render_errors: [view: CookbookWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Cookbook.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
