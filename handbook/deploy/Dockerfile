ARG BUILDER_IMAGE="node:20.3.0-alpine3.18"
ARG RUNNER_IMAGE="alpine:3.18"

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

RUN apk add \
  nginx \
  && rm -rf /var/cache/apk/*

COPY --from=builder /app/.vitepress/dist /usr/share/nginx/html/

CMD ["nginx", "-g", "daemon off;"]
