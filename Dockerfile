FROM debian AS build

# Hugo version
ARG VERSION=0.135.0
ADD https://github.com/gohugoio/hugo/releases/download/v${VERSION}/hugo_extended_${VERSION}_Linux-64bit.tar.gz /hugo_extended.tar.gz
RUN tar -zxvf hugo_extended.tar.gz
RUN /hugo version

# for --enableGitInfo
RUN apt-get update && apt-get install -y git

COPY . /site
WORKDIR /site

RUN /hugo --minify --enableGitInfo

# stage 2
FROM nginx:alpine

WORKDIR /usr/share/nginx/html/

# clean the default public folder
RUN rm -fr * .??*

COPY _docker/nginx.conf /etc/nginx/nginx.conf
COPY _docker/conf.d/ /etc/nginx/conf.d/

RUN chmod 0644 /etc/nginx/nginx.conf /etc/nginx/conf.d/*

COPY --from=build /site/public /usr/share/nginx/html
