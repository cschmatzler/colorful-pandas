ARG BUILDER_IMAGE="hexpm/elixir:1.15.0-erlang-26.0.1-debian-buster-20230612-slim"
ARG RUNNER_IMAGE="debian:buster-20230612-slim"

# Builder
# -----

FROM ${BUILDER_IMAGE} as builder

RUN apt-get update && apt-get upgrade -y && \
    apt-get install --no-install-recommends -y \
        build-essential git && \
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

ENV MIX_ENV=prod
ENV ERL_FLAGS="+JPperf true +JMsingle true"

RUN mix local.hex --force && \
    mix local.rebar --force

COPY mix.exs mix.lock ./
COPY config config

RUN mix do deps.get, deps.compile

COPY rel rel
COPY lib lib

RUN mix do compile, release colorful_pandas

# Runner
# ------

FROM ${RUNNER_IMAGE}

WORKDIR /app

COPY --from=builder /app/_build/prod/rel/colorful_pandas /app

CMD ["/app/bin/colorful-pandas", "start"]
