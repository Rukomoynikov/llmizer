FROM elixir:latest

WORKDIR /app

# Install dependencies
COPY mix.exs mix.lock ./
RUN mix do local.hex --force, local.rebar --force, deps.get

COPY . .

ENTRYPOINT ["/app/entrypoint.sh"]

CMD ["mix", "phx.server"]
