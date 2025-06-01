#!/bin/sh -e

mix deps.get
mix deps.compile
mix ecto.create || true
mix ecto.migrate || true

exec "${@}"
