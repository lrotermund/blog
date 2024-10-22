---
type: post
title: "I retired NGINX for Caddy - and never looked back"
tags: ["hosting", "docker", "nginx", "caddy"]
date: 2024-10-18T22:58:40+02:00
images: ["/assets/nginx_caddy.webp"]
image_alt: |
    This meme humorously depicts a man labeled "CADDY" posing with a peace sign
    next to a gravestone labeled "NGINX," implying that the Caddy web server is
    celebrating and taking over as a replacement for NGINX.
description: |
    In this article, I explain why I replaced NGINX with Caddy as the reverse
    proxy on the host machine and in the Docker image.
summary: |
    In this article, I explain why I replaced NGINX with Caddy as the reverse
    proxy on the host machine and in the Docker image.
toc: false
draft: false
---

In my previous post
[Docker + ufw: When convenience turns into a security risk]({{< ref "docker-and-ufw_when-convenience-turns-into-a-security-risk" >}}),
I described how my VPS was attacked with a DoS, enabled by Docker's default
behaviour of exposing ports and ignoring the firewall (ufw). Thanks to the
friendly recommendation of [@lil5@fosstodon.org](https://fosstodon.org/@lil5) on
Mastodon that a Caddy setup would have been much easier to implement, I ended up
migrating my entire setup to the Caddy webserver the next day.

{{< toc >}}

## Everyone knows NGINX, but what is Caddy?

After lil5 recommended Caddy, my first reaction was: "Caddy? What the hell is
Caddy?". But I was curious, so I promised to look it up.

I don't think there is a developer who hasn't heard of NGINX. I used to run
Apache as my webserver, on a local WAMP stack and a LAMP stack on my server.
After a while, maybe in 2015 or 2016, I switched to the NGINX webserver to run
my PHP Laravel applications. It was much faster and easier to set up and
customise than an Apache.

And I've been using it for years. First as a webserver, always for PHP
applications like Laravel and for WordPress sites provided by the web agency I
worked for. Later, I also used it as a reverse proxy here and there, especially
when migrating my "bare metal" PHP applications to Docker images.

But now there is a new cool kid, Caddy. After looking it up, I recognised it.
I remembered that
[FrankenPHP, a modern PHP app server](https://frankenphp.dev/), was a custom
build of the Caddy server. That was promising.

OK, now about Caddy, enough of the old stories. Caddy is a new, batteries
included server, written in the best programming language, Go, which makes it
memory safe and highly concurrent.

Its biggest feature, advertised on the Caddy website, is its built-in automatic
TLS certificate handling for ALL the sites it manages. Caddy will take care of
obtaining and renewing certificates for real domains as well as internal
self-signed TLS certificates and also your own CAs, just by providing your ACME
endpoint.

But Caddy comes with a lot more features than "just" automatic TLS. It also has
built-in support for proxy HTTP, FastCGI (PHP), WebSockets and gRPC. It gives
you on-the-fly lossless compression, such as Zstandard (zstd) and gzip.

And with Caddy, you can provide access to virtual file systems such as remote
cloud storage, databases and even embedded file systems statically compiled into
the Caddy binary.

You can read more about Caddy's features on its website:
[caddyserver.com](https://caddyserver.com/)

## NGINX config vs Caddy config - on the VPS

Let's see how Caddy has changed my configs. Lets compare my "new" NGINX config
from my last post with my new final Caddy config.

### NGINX

We will start with the NGINX config(s) on my VPS host:

**/etc/nginx/nginx.conf**

```sh
user             www-data;
worker_processes auto;
pid              /var/run/nginx.pid;

events {
    worker_connections 1024;
}

http {
    include           /etc/nginx/mime.types;
    default_type      application/octet-stream;
    sendfile          on;
    keepalive_timeout 65;

    ##
    # Disable logging because we care about
    # privacy.
    #
    # `off` is a valid option for access_log
    # since nginx 1.5.6
    # => https://nginx.org/en/docs/http/ngx_http_log_module.html#access_log
    #
    # Until today there is no valid `off`
    # option for error logs so we just write
    # it to /dev/null to send it to the nether.
    # => https://nginx.org/en/docs/ngx_core_module.html#error_log
    ##

    access_log off;
    error_log  /dev/null;

    ##
    # `gzip` Settings
    #
    gzip on;

    # 1-9
    gzip_comp_level 6;

    # Puffer
    gzip_buffers 16 8k;

    # Minimal size for gzip (in bytes)
    gzip_min_length 256;

    # compress also headers
    gzip_proxied any;

    # enabled mimes for compression
    gzip_types text/plain
               text/css
               text/javascript
               application/javascript
               application/x-javascript
               application/json
               application/xml
               application/rss+xml
               application/atom+xml
               application/vnd.ms-fontobject
               application/x-font-ttf
               font/opentype
               font/otf
               font/ttf
               font/woff
               font/woff2
               image/svg+xml
               image/x-icon;

    # enable gzip for all versions
    gzip_http_version 1.1;

    # 'Vary: Accept-Encoding' adds header
    gzip_vary on;

    # gzip for proxied requests
    gzip_proxied expired no-cache no-store private auth;

    # disable gzip for IE6
    gzip_disable "msie6";

    include /etc/nginx/conf.d/*.conf;
}
```

As well as the sites config:

**/etc/nginx/conf.d/lukasrotermund.de.conf**

```sh
server {
    server_name   lukasrotermund.de www.lukasrotermund.de;
    server_tokens off;

    location /.well-known/acme-challenge/ {
        root /var/www/certbot;
    }

    location / {
        return 301 https://lukasrotermund.de$request_uri;
    }
}

server {
    server_name lukasrotermund.de;

    ##
    # Added and managed by Certbot
    ##
    listen              [::]:443 ssl ipv6only=on;
    listen              443 ssl;
    ssl_certificate     /etc/letsencrypt/live/lukasrotermund.de/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/lukasrotermund.de/privkey.pem;
    include             /etc/letsencrypt/options-ssl-nginx.conf;
    ssl_dhparam         /etc/letsencrypt/ssl-dhparams.pem;

    location / {
        proxy_pass       http://127.0.0.1:8000;
        proxy_set_header Host $host;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

### Caddy

And here is my single new Caddy configuration:

**/etc/caddy/Caddyfile**

```sh
lukasrotermund.de {
	encode zstd gzip
	reverse_proxy 127.0.0.1:8000

	header {
		-Server
	}
}
```

**That's it**. And TLS certificate handling is included. I can also disable my
local Certbot and cron to renew my certificate. If that's not simplicity, I
don't know what is.

It took me 10 minutes tops to set up Caddy and the config, disable NGINX and
enable the Caddy service. 10 minutes. I haven't benchmarked it but even my tiny
*static site* (pre-rendered by hugo) feels a lot faster then with NGINX.

I think the main reason for this is the switch from gzip to zstd and the fact
that **Caddy can talk not only HTTP/1 but also 2 & 3!**

## NGINX config vs Caddy config - within docker

I also need a file server inside the running docker container of my blog because
its a statically rendered site using the
[hugo static site builder](https://gohugo.io/). So I also used an NGINX server.
Let's compare how they have changed, including the Dockerfiles. And we start
with NGINX again.

### NGINX

My Dockerfile was simple and contained a build stage and a final stage based on
the NGINX alpine image. I removed all the NGINX defaults, copied all the NGINX
configs to the image and finally the public folder of the build stage with all
the HTML files generated by hugo.

```Docker
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
```

This is the main NGINX config: **_docker/nginx.conf**

```sh
user  nginx;
worker_processes  auto;
pid        /var/run/nginx.pid;

events {
    worker_connections  1024;
}

http {
    include           /etc/nginx/mime.types;
    default_type      application/octet-stream;
    sendfile          on;
    keepalive_timeout 65;
    access_log        off;
    error_log         /dev/null;
    server_tokens     off;

    # Include your custom configuration file
    include /etc/nginx/conf.d/*.conf;
}
```

And an additional NGINX config to handle some caching headers:
**_docker/conf.d/expires.inc**

```sh
# cache.appcache, your document html and data
location ~* \.(?:manifest|appcache|html?|xml|json)$ {
  expires -1;
}

# Feed
location ~* \.(?:rss|atom)$ {
  expires 1h;
  add_header Cache-Control "public";
}

# Media: images, icons, video, audio, HTC
location ~* \.(?:jpg|jpeg|gif|png|ico|cur|gz|svg|svgz|mp4|ogg|ogv|webm|htc)$ {
  expires 1M;
  access_log off;
  add_header Cache-Control "public";
}

# CSS and Javascript
location ~* \.(?:css|js)$ {
  expires 1y;
  access_log off;
  add_header Cache-Control "public";
}
```

### Caddy

The Dockerfile lost the cleanup and differs in the base image of the second
stage. Here I just use Caddy's alpine image instead of NGINX's:

```Docker
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
FROM caddy:alpine

COPY _docker/Caddyfile /etc/caddy/Caddyfile

RUN chmod 0644 /etc/caddy/Caddyfile

WORKDIR /var/www/html

COPY --from=build /site/public /var/www/html
```

The Caddy config for my file server is not significantly smaller then the NGINX
config, due to the cache control headers. The most important part of the
config is the last line, where I specify, that this is just a file server that
serves the static html files of my blog.

I like the structure of the Caddy file. With the @ prefixed matchers it is easy
to bundle and tag a bunch of matching rules based on the path or a path regex,
headers or HTTP methods.

But yes, there is no real improvement over NGINX's location group format.

**_docker/Caddyfile**

```sh
:80 {
	header {
		-Server
	}

	@manifest path_regexp \.(manifest|appcache|html?|xml|json)$
	header @manifest {
		Expires "-1"
	}

	@feeds path_regexp \.(rss|atom)$
	header @feeds {
		Expires "1h"
		Cache-Control "public"
	}

	@media path_regexp \.(jpg|jpeg|gif|png|ico|svg|webp)$
	header @media {
		Expires "1M"
		Cache-Control "public"
	}

	@assets path_regexp \.(css|js)$
	header @assets {
		Expires "1y"
		Cache-Control "public"
	}

	@fonts path_regexp \.(woff|woff2)$
	header @fonts {
		Expires "1y"
		Cache-Control "public"
	}

	file_server
}
```

## Final thoughts

I just like things to be simple. That was the reason I replaced K3S with Docker.
I have enough to think about all day and I like it when I don't have to deal
with complexity. Complexity kills progress.

Caddy looks really promising and is crazy fast. I love the simple Caddyfile
syntax with the batteries-included-modules that Caddy provides. It comes with
everything I need for my day-to-day work.

And Caddy is already supported by major companies that work with Caddy in
production. There are companies like stripe, Les-Tilleuls (big in the
PHP-Symfony space), Sourcegraph and many more. So there is a real interest in
keeping it developed and secure.

The Let's Encrypt community is also discussing making Caddy the default ACME
client instead of Certbot, but I couldn't find an official statement from Let's
Encrypt on this. The statement was made in a [Backend Banter interview with
Caddy creator, Matt Holt](https://www.youtube.com/watch?v=rbGwdUjg1Bs)
(timestamp: ~30:50).

I guess it doesn't really matter which reverse proxy/ file server I use for my
blog, but I could see using it in larger projects.

For now it's helpful, it's small & simple, it's not in my way and it feels much
faster than NGINX. Maybe NGINX had a bigger problem with the reduced IO on my
VPS than Caddy does. I don't know. But please don't hesitate to tell me if you
know why Caddy outperforms NGINX. I am really curious.

Have you worked with Caddy before? What are your experiences and are you using
it in a production environment?

Please share your thoughts and concerns about Caddy vs. NGINX. You can easily
contact me on Mastodon at my handle:
[@lukasrotermund@social.tchncs.de](https://social.tchncs.de/@lukasrotermund)
