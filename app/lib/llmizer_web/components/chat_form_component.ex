# defmodule LlmizerWeb.ChatFormComponent do
#  def form(assigns) do
#    ~H"""
#    <%= f = form_for @changeset, "#", [phx_change: :validate, phx_submit: :save] %>
#      <%= label f, :name %>
#      <%= text_input f, :name %>
#      <%= error_tag f, :name %>
#
#      <%= submit "Save" %>
#    </form>
#    """
#  end
# end
