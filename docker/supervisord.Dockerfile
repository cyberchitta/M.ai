ARG ELIXIR_VERSION=1.16.2
ARG OTP_VERSION=26.2.4
ARG DEBIAN_VERSION=bookworm-20240408-slim

ARG BUILDER_IMAGE="hexpm/elixir:${ELIXIR_VERSION}-erlang-${OTP_VERSION}-debian-${DEBIAN_VERSION}"
ARG RUNNER_IMAGE="debian:${DEBIAN_VERSION}"

# Stage 1: Build the Elixir project
FROM ${BUILDER_IMAGE} as builder

# Install build dependencies
RUN apt-get update -y && apt-get install -y build-essential git curl \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Node.js 20 and npm
RUN curl -sL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

ENV MIX_ENV=prod

WORKDIR /app

# Install Hex and Rebar
RUN mix local.hex --force && mix local.rebar --force

# Copy and compile Elixir dependencies
COPY mix.exs mix.lock ./
RUN mix deps.get --only $MIX_ENV
RUN mkdir config

# Copy compile-time config files before compiling dependencies
COPY config/config.exs config/prod.exs config/
RUN mix deps.compile

# Copy project files
COPY priv priv
COPY lib lib
COPY assets assets

# Install Node.js dependencies and compile assets
RUN npm install --prefix ./assets
RUN mix assets.deploy

# Compile the release
RUN mix compile
COPY config/runtime.exs config/
COPY rel rel
RUN mix release

# Stage 2: Build the final image
FROM ${RUNNER_IMAGE} as with_postgres

# Install required tools
RUN apt-get update -y && apt-get install -y curl gnupg

# Add PostgreSQL APT Repository
RUN echo "deb http://apt.postgresql.org/pub/repos/apt bookworm-pgdg main" > /etc/apt/sources.list.d/pgdg.list && \
    curl -sL https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -

# Install runtime dependencies and PostgreSQL 15
RUN apt-get update -y && \
    apt-get install -y libstdc++6 openssl libncurses5 locales ca-certificates \
    postgresql-15 postgresql-client-15 supervisor && \
    apt-get remove --purge -y curl gnupg && \
    apt-get autoremove -y && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Set the locale
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Set up PostgreSQL
RUN mkdir -p /var/lib/postgresql/data

ENV MIX_ENV=prod

# Set work directory
WORKDIR /app

# Ensure proper permissions and ownership
RUN chown -R nobody /app
RUN chown -R nobody /var/lib/postgresql
RUN chmod +x /app/start_elixir.sh

# Only copy the final release from the build stage
COPY --from=builder --chown=nobody:nobody /app/_build/${MIX_ENV}/rel/mai ./

# Copy the startup script
COPY docker/start_elixir.sh /app/start_elixir.sh
RUN chmod +x /app/start_elixir.sh

# Copy supervisord configuration
COPY docker/supervisord.conf /etc/supervisord.conf

USER nobody

# Expose the Elixir app port
EXPOSE 4000

# Command to start supervisord
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
