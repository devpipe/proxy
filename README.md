
# Proxy

`Proxy` is a Plug module for Elixir that allows you to easily forward HTTP requests from one path to another URL while preserving subpaths. It simplifies the process of setting up reverse proxies in your Elixir applications.

## Features

- Forward HTTP requests to a specified URL.
- Preserve subpaths in forwarded requests.
- Automatically handle and forward headers and request bodies.
- Simple macro-based syntax for easy integration into Plug routers.

## Installation

Add `proxy` to your list of dependencies in `mix.exs`:

```elixir
defp deps do
  [
    {:proxy, "~> 0.1.0"},
  ]
end
```

Then run `mix deps.get` to fetch the dependencies.

## Usage

To use the `Proxy` module, first import it into your Plug router, and then use the `proxy` macro to define the paths you want to forward.

### Example

```elixir
defmodule MyRouter do
  use Plug.Router

  import Proxy

  plug :match
  plug :dispatch

  proxy "/path", to: "https://localhost:8080"

  match _ do
    send_resp(conn, 404, "Oops!")
  end
end
```

In this example, any request made to `/path` (e.g., `/path/resource`) will be forwarded to `https://localhost:8080/resource`.


#### Another Example

```elixir
proxy "/api", to: "https://api.example.com"
```

This forwards requests like `/api/resource` to `https://api.example.com/resource`.


## License

This project is licensed under the MIT License.
