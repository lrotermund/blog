FROM debian AS build

# Hugo version
ARG VERSION=0.142.0
ADD https://github.com/gohugoio/hugo/releases/download/v${VERSION}/hugo_extended_${VERSION}_Linux-64bit.tar.gz /hugo_extended.tar.gz
RUN tar -zxvf hugo_extended.tar.gz
RUN /hugo version

# for --enableGitInfo
RUN apt-get update && apt-get install -y git

COPY . /site
WORKDIR /site

RUN /hugo --minify --enableGitInfo

# stage 2
FROM caddy:alpine

COPY _docker/Caddyfile /etc/caddy/Caddyfile

RUN chmod 0644 /etc/caddy/Caddyfile

WORKDIR /var/www/html

COPY --from=build /site/public /var/www/html
