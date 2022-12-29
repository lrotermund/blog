FROM debian AS build

# Hugo version
ARG VERSION=0.107.0
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

# This inserts a line in the default config file, including our file "expires.inc"
RUN sed -i '9i\        include /etc/nginx/conf.d/expires.inc;\n' /etc/nginx/conf.d/default.conf

# The file "expires.inc" is copied into the image
COPY _docker/expires.inc /etc/nginx/conf.d/expires.inc
RUN chmod 0644 /etc/nginx/conf.d/expires.inc

COPY --from=build /site/public /usr/share/nginx/html