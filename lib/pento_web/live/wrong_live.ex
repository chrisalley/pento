defmodule PentoWeb.WrongLive do
  use PentoWeb, :live_view

  alias Pento.Accounts

  def mount(_params, session, socket) do
    {
      :ok,
      assign(
        socket,
        score: 0,
        message: "Guess a number:",
        session_id: session["live_socket_id"],
        correct_number: Enum.random(1..10)
      )
    }
  end

  @spec render(any) :: Phoenix.LiveView.Rendered.t()
  def render(assigns) do
    ~H"""
    <h1>Your score: <%= @score %></h1>
    <h2><%= @message %></h2>
    <h2>
      <%= for n <- 1..10 do %>
        <.link href="#" phx-click="guess" phx-value-number={n}>
          <%= n %>
        </.link>
      <% end %>
      <pre>
        <%= @current_user.email %>
        <%= @session_id %>
      </pre>
    </h2>
    """
  end

  def handle_event("guess", %{"number" => guess}, socket) do
    message = if guess_correct?(guess, socket) do
      "Your guess: #{guess} was correct."
    else
      "Your guess: #{guess}. Wrong. Guess again."
    end
    score = if guess_correct?(guess, socket) do
      socket.assigns.score + 1
    else
      socket.assigns.score - 1
    end
    {
      :noreply,
      assign(socket, message: message, score: score)
    }
  end

  def guess_correct?(guess, socket) do
    String.to_integer(guess) == socket.assigns.correct_number
  end
end
