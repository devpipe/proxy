defmodule Proxy do
  @moduledoc """
  `Proxy` is a Plug module that allows you to forward requests to another URL while preserving subpaths.

  ## Example Usage

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

  The `proxy/2` macro is used to forward requests from `/path` to `https://localhost:8080`.
  """

  import Plug.Conn

  @doc """
  Defines a macro to simplify request forwarding. It forwards all requests matching the specified path
  to the given target URL, preserving subpaths.

  ## Parameters

    - `path`: The path to match and forward (e.g., `"/path"`).
    - `opts`: Options, including the `:to` key, which specifies the target URL.

  ## Example

      proxy "/api", to: "https://api.example.com"

  This forwards requests like `/api/resource` to `https://api.example.com/resource`.
  """
  defmacro proxy(path, opts) do
    quote do
      forward unquote(path), to: Proxy, init_opts: [to: unquote(opts[:to])]
    end
  end

  @doc """
  Initializes the `Proxy` plug with the target URL.

  ## Parameters

    - `to`: The target URL to which requests will be forwarded.

  Returns the target URL, which is passed to the `call/2` function.
  """
  def init(to), do: to

  @doc """
  Handles the forwarding of requests to the specified target URL. It preserves the subpaths of the original
  request and forwards the request to the target URL, including the request body, headers, and method.

  The `Content-Type` header from the target URL response is also preserved.

  ## Parameters

    - `conn`: The connection struct (`Plug.Conn`).
    - `to`: The target URL to which requests are forwarded.

  ## Example

      proxy "/path", to: "https://localhost:8080"

  This forwards `/path/resource` to `https://localhost:8080/resource`.
  """
  def call(%Plug.Conn{request_path: original_path, method: method, req_headers: headers, body_params: body} = conn, to) do
    # Remove the forward base path from the original path to preserve subpaths
    base_path = conn.script_name |> Enum.join("/")
    subpath = String.replace_leading(original_path, base_path, "")

    target_url = "#{to}#{subpath}"

    response =
      HTTPoison.request!(method, target_url, body, headers)

    content_type = response.headers
                   |> Enum.find(fn {key, _value} -> String.downcase(key) == "content-type" end)
                   |> elem(1)

    conn
    |> put_resp_content_type(content_type)
    |> send_resp(response.status_code, response.body)
  end
end
