defmodule LlmizerWeb.PageController do
  use LlmizerWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    dbg(System.get_env("AI_RUNNER_URL") || false)
    dbg(System.get_env("AI_RUNNER_MODEL") || false)

    render(conn, :home, layout: false)
  end
end
