ARG BUILDER_IMAGE="hexpm/elixir:1.14.5-erlang-26.0.2-debian-buster-20230612-slim"
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

COPY lib lib
COPY assets assets
COPY rel rel
COPY priv priv

RUN mix do tailwind.install --if-missing, esbuild.install --if-missing
RUN mix do tailwind default --minify, esbuild default --minify, phx.digest
RUN mix do compile, release colorful_pandas

# Runner
# ------

FROM ${RUNNER_IMAGE}

RUN apt-get update && apt-get upgrade -y && \
    apt-get install --no-install-recommends -y \
        ca-certificates locales openssl && \
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/*

RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

WORKDIR /app

COPY --from=builder /app/_build/prod/rel/colorful_pandas /app

CMD ["/app/bin/server"]
