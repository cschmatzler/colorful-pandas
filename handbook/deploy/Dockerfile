ARG BUILDER_IMAGE="node:20.3.0-alpine3.18"
ARG RUNNER_IMAGE="busybox:1.36"

# Builder
# -----

FROM ${BUILDER_IMAGE} as builder

WORKDIR /app

COPY . /app

RUN npm ci
RUN npm run build

# Runner
# ------

FROM ${RUNNER_IMAGE}

RUN adduser -D static
USER static
WORKDIR /home/static

COPY --from=builder /app/.vitepress/dist .

EXPOSE 3000
CMD ["busybox", "httpd", "-f", "-v", "-p", "3000"]
