import Config

config :kickplan, :base_url, "https://demo-control.fly.dev/api"

if File.exists?("config/config.secret.exs") do
  import_config "config.secret.exs"
end
