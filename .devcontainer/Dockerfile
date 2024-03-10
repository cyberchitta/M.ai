FROM hexpm/elixir:1.16.2-erlang-26.2.2-debian-bookworm-20240130

ENV DEBIAN_FRONTEND noninteractive

ARG PHOENIX_VERSION=1.7.11

RUN apt-get update && apt-get upgrade -y && \
  apt-get install -y git && \
  apt-get install -y apt-utils && \
  apt-get install -y build-essential && \
  apt-get install -y inotify-tools && \
  apt-get autoremove -y && \
  apt-get clean -y && \
  rm -rf /var/lib/apt/lists/* && \
  mix local.rebar --force && \
  mix local.hex --force && \
  mix archive.install --force hex phx_new #{PHOENIX_VERSION}
