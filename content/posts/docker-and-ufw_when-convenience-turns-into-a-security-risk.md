---
type: post
title: "Docker + ufw: When convenience turns into a security risk"
tags: ["hosting", "docker", "ufw", "security", "nginx"]
date: 2024-10-03T21:00:40+02:00
images: ["/assets/docker-ufw-disaster-girl.webp"]
image_alt: |
    This image is a meme showing a young girl smirking while a house burns in
    the background. The text overlay reads "MY VPS" over the burning house and
    "DOCKER" over the girl's face. The image humorously suggests that Docker,
    represented by the girl, is responsible for the disaster, while the Virtual
    Private Server (VPS) is going up in flames.
description: |
    Learn how Docker can bypass ufw, exposing your VPS, and how to secure your
    setup against this hidden vulnerability.
summary: |
    Learn how Docker can bypass ufw, exposing your VPS, and how to secure your
    setup against hidden vulnerabilities.
toc: false
draft: false
---

My personal blog runs on a basic VPS running Ubuntu. Until this year, my setup
was a bit more complicated than necessary. I used to run a K3S single node
Kubernetes to learn some K8S basics. Then I switched to a much simpler setup
based on Docker Compose to drastically reduce the complexity of running things
on my VPS. A few weeks ago I noticed that my blog was down. And that's when I
learned that I could no longer rely on Docker.

{{< toc >}}

## What happened

As soon as I saw that I couldn't access my blog, I jumped on my laptop and tried
to connect to my server. And then, nothing. Timeout after timeout. After a while
I got a connection, but I couldn't type. What the hell was happening?

The only time I have ever experienced anything like this was when electron
apps like MS Teams or Slack used up a lot of memory in the early days and my
laptop ran out of memory.

In addition, Ubuntu was printing a lot of `BUG: soft lockup - CPU#X stuck for
Xs!` messages. After some research and a few conversations on Mastodon, I got a
rough idea of what was happening to my VPS - a classic brute force attack.

OK, first of all, I wasn't prepared, that was my fault. Absolute rookie
mistakes. I had a ufw up and running and only allowed 80/tcp, 443/tcp, OpenSSH,
some teamspeak and minecraft server ports. I also disabled password logins for
my users. But that's it. That was all the protection I had for my server.

So I cleaned up, removed the unused teamspeak and minecraft containers, closed
the unnecessary ports, changed my ssh port to stop newbie script kiddies and
installed **fail2ban**. Yes... I forgot to reinstall fail2ban after a clean
server refresh last year. So this should reduce failed ssh logins, and I was
getting a lot of them. Within an hour I found **~20,000 failed login attempts**,
and **several hundred thousand** before that. I also switched from ufw `allow`
to `limit` to add rate limiting to all my connections, especially for 80/tcp and
443/tcp. `limit` reduces the allowed requests per IP address within 30 seconds
to six. That's pretty radical, and OK for ssh, but not for ports 80 and 443. But
it was fine for the moment to reduce the load on my server.

The server stabilised. A bit. After a few minutes, the server crashed again,
leaving me confused. I looked a lot in my **journalctl**, in **htop** and in my
freshly enabled ufw logs. And I saw a lot of rate limiting ufw blocks on all the
restricted ports. Strange. I shut down my server for a few days out of
frustration.

## Docker & ufw - even a blind man may perchance hit the mark

I had some time after work and started up my server again. This time I even
blocked 80/tcp and 443/tcp inside the ufw to stop the brute force requests
coming in. And then I waited. Maybe two minutes. And then it crashed again.
What the hell.

And then, confused and frustrated as I was, I enabled request logging within
my blogs container and was even more confused. I was seeing incoming requests
and my blog container was constantly dying and restarting. This was strange. So
I started **nmap** and checked my open ports and there it was, 80/tcp and
443/tcp still open even after removing them and restarting the ufw.

So I jumped to duckduckgo and looked for clues. And I found some.

## The problem with a Docker and ufw

To be clear, I'm not a networking expert, and certainly not a Docker networking
expert. But I have found that Docker adds its own iptables chains to enable
internal Docker networking and connection to the host. And these rules end up
in front of the ufw iptables chains. So I was fooled.

ufw never played a damn role in protecting my ports 80 and 443 from incoming
traffic. This is a really dangerous and stupid behaviour.

For me, Docker was the epitome of simplicity. Prepare a simple environment for
your application in your Dockerfile, build it and ship it somewhere and run it
as a container with a nice and easy to control way of mapping ports.

And it doesn't work with a tool as important as ufw, the uncomplicated firewall.
That was the moment I lost my faith in Docker. Maybe it is just me who thinks
this is wrong and this is fine for me.

So I talked to my colleague [Tobias](https://amarth.dev/),
[Andreas Lehr](https://andreas-lehr.com) from tasko's managed hosting partner
[We Manage](https://we-manage.de/) and some guys from a local hackspace, and
thankfully they all pointed me in a similar direction.

## The solution that finally worked for me

{{< aside >}}
Shortly after this post was published, I moved away from NGINX as a reverse
proxy and file server. You can read more about this in my latest blog post: 

[I retired NGINX for Caddy - and never looked back]({{< ref "i-retired-nginx-for-caddy-and-never-looked-back" >}})
{{< /aside >}}

I decided to remove my Docker-internal nginx reverse proxy that I was using as
an entry point into my running Docker Compose environment. I then installed a
local, old school nginx on the host system and added the following root nginx
config:

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

And also an nginx config for my blog. Remember to start with a simple config
without an encrypted 443 setup, because Certbot will extend this config during
setup. After the Certbot setup it was important for me to remove some settings
to prevent nginx from forwarding the clients IP address. In the end it is only
important to enable SSL encryption. So this is the final version for my site:

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

With nginx running on port 80, I removed my Docker nginx reverse proxy and the
Docker certbot services from my Docker Compose yaml. It is also important to
clean up the default nginx site config. Don't be messy with your configs.

**The next step is important**. My blog container was only internally accessible
because there was no port mapping to my host. But to run into the "Docker
problem" of open ports, we need to map it to our loopback IP address
**127.0.0.1**, which is only reachable locally on our host. This is what you see
in the nginx site config for the `proxy_pass` option. Later, nginx will take
care of forwarding the traffic to our site.

```yaml
services:
    blog:
        image: lrotermund/blog
        restart: always
        ports:
          - 127.0.0.1:8000:80
```

As mentioned before, it is important to install Certbot if you want to use
simple SSL encryption. Before running the next commands, make sure that your
site is reachable unencrypted on port 80, so that Certbot can reach it.

I just installed and activated it:

```sh
$ sudo apt install certbot python3-certbot-nginx
$ sudo certbot --nginx -d lukasrotermund.de
```

After the setup, go back to the site config and modify it as I did to remove
unnecessary options added by Certbot.

## Extending ufw rules - DoS protection and rate limiting

Now that I could rely on ufw again, I looked for a better rate limit than the
steamroller approach of setting `ufw limit 80/tcp` and 443/tcp. The best way to
do this is to extend the `/etc/ufw/before.rules`.

I found this older guide, [Le Pepe: Protect Ubuntu Server Against DOS Attacks
with UFW](https://lepepe.github.io/sysadmin/2016/01/19/ubuntu-server-ufw.html),
from 2016, which describes how to add the following rules:

Make sure your `before.rules` contains the iptables chain definitions somewhere
at the beginning of the file, next to the `*filter` within the `# CUSTOM UFW`
section:

```sh
# CUSTOM UFW
:ufw-http - [0:0]
:ufw-http-logdrop - [0:0]
# END CUSTOM
```

Now scroll to the bottom of the file to the `COMMIT` and add the following
section before committing:

```sh
### CUSTOM HTTP RULES
# Enter rule
-A ufw-before-input -p tcp --dport 80 -j ufw-http
-A ufw-before-input -p tcp --dport 443 -j ufw-http

# Limit connections per Class C
-A ufw-http -p tcp --syn -m connlimit --connlimit-above 50 --connlimit-mask 24 -j ufw-http-logdrop

# Limit connections per IP
-A ufw-http -m state --state NEW -m recent --name conn_per_ip --set
-A ufw-http -m state --state NEW -m recent --name conn_per_ip --update --seconds 10 --hitcount 45 -j ufw-http-logdrop

# DDOS (with GDPR compliant IP masking)
-A ufw-http -m hashlimit --hashlimit 100/sec --hashlimit-burst 30 --hashlimit-mode srcip --hashlimit-name nginx_DDOS --hashlimit-htable-expire 30000 --hashlimit-htable-max 65535 -j ACCEPT
-A ufw-http -j LOG --log-prefix "[UFW DDOS DROP]" --log-ipmask 255.255.255.0
-A ufw-http -j DROP

# Finally accept
-A ufw-http -j ACCEPT

# Log (GPDR complient due to IP masking)
-A ufw-http-logdrop -m limit --limit 3/min --limit-burst 10 -j LOG --log-prefix "[UFW HTTP DROP] " --
-A ufw-http-logdrop -j DROP

# don't delete the 'COMMIT' line or there rules won't be processed
COMMIT
```

In the rules you can see that we are redirecting traffic from ports 80 and 443
to the `ufw-http` chain to apply a more stringent filtering. Now restart your
ufw to load the new rules and benefit from the better and more realistic rules.

## My learnings...

I could pick on Docker again, but I know it's not that easy to build something
that should be easy to use and easy to deploy. Docker had a good and safe place
in my developer toolkit for a long time because of that.

But it has lost that place. And rightly so. For a company and a product like
Docker, it is IMHO not OK not to mention this kind of severity. If "simple"
applications like Docker and ufw don't work together, that's not good. And I
can't imagine, I'm the only person who's run into this problem.

It is still convenient to be able to bundle my small application environments
into Docker images and run them on my server. But for me, Docker has lost its
reputation for simplicity.

It is always the same. In the end, convenience leads to security risks. I forgot
to dig deeper and to protect my server better because magic-Docker takes care of
running my containers.

What are your experiences with running Docker in "production"? I am curious if
you knew about this risk and how you solved it.

You can easily contact me on mastodon under my handle:
`@lukasrotermund@social.tchncs.de`
