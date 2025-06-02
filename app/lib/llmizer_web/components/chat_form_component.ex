defmodule LlmizerWeb.ChatFormComponent do
  use LlmizerWeb, :live_component

  def render(assigns) do
    ~H"""
    <div>
      <h2>New Chat Message</h2>

      <.simple_form for={@form} phx-change="validate" phx-submit="save">
        <.input field={@form[:content]} label="Message"/>
        <button>Save</button>
    </.simple_form>
    </div>
    """
  end
end
