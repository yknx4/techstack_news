FROM elixir:1.11-alpine AS build

# install build dependencies
RUN apk add --no-cache build-base npm git && npm install -g yarn

# prepare build dir
WORKDIR /app

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# set build ENV
ENV MIX_ENV=prod
ENV NODE_ENV=production

# install mix dependencies
COPY mix.exs mix.lock ./
COPY config config
RUN mix do deps.get, deps.compile

# build assets
COPY assets/package.json assets/yarn.lock ./assets/
RUN cd assets && yarn install --frozen-lockfile

COPY priv priv
COPY assets assets
RUN cd assets && yarn deploy
RUN mix phx.digest

# compile and build release
COPY lib lib
# uncomment COPY if rel/ exists
# COPY rel rel
ENV MIX_ENV prod
RUN mix do compile, release

# prepare release image
FROM alpine:3.9 AS app
RUN apk add --no-cache openssl ncurses-libs npm && npm install -g yarn

WORKDIR /app

RUN chown nobody:nobody /app

USER nobody:nobody

COPY --from=build --chown=nobody:nobody /app/_build/prod/rel/techstack_news ./

ENV HOME=/app
ENV MIX_ENV prod
RUN yarn add techstack-news-crawler

CMD ["bin/techstack_news", "start"]