FROM alpine:3.5

# Originally Derived From: NGINX Docker Maintainers <docker-maint@nginx.com>
LABEL maintainer="Bohan Yang <contact@bohan.co>"

ENV PCRE_VERSION 8.41
ENV ZLIB_VERSION 1.2.11
ENV OPENSSL_VERSION 1_0_2n
ENV NGINX_CT_VERSION 1.3.2
ENV NGINX_VERSION 1.13.7

RUN GPG_KEYS=B0F4253373F8F6F510D42178520A9993A1C052F8 \
    && CONFIG="\
        --prefix=/etc/nginx \
        --sbin-path=/usr/sbin/nginx \
        --modules-path=/usr/lib/nginx/modules \
        --conf-path=/etc/nginx/nginx.conf \
        --error-log-path=/var/log/nginx/error.log \
        --http-log-path=/var/log/nginx/access.log \
        --pid-path=/var/run/nginx.pid \
        --lock-path=/var/run/nginx.lock \
        --http-client-body-temp-path=/var/cache/nginx/client_temp \
        --http-proxy-temp-path=/var/cache/nginx/proxy_temp \
        --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
        --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
        --http-scgi-temp-path=/var/cache/nginx/scgi_temp \
        --user=nginx \
        --group=nginx \
        --with-http_ssl_module \
        --with-http_realip_module \
        --with-http_addition_module \
        --with-http_sub_module \
        --with-http_dav_module \
        --with-http_flv_module \
        --with-http_mp4_module \
        --with-http_gunzip_module \
        --with-http_gzip_static_module \
        --with-http_random_index_module \
        --with-http_secure_link_module \
        --with-http_stub_status_module \
        --with-http_auth_request_module \
        --with-http_xslt_module=dynamic \
        --with-http_image_filter_module=dynamic \
        --with-http_geoip_module=dynamic \
        --with-threads \
        --with-stream \
        --with-stream_ssl_module \
        --with-stream_ssl_preread_module \
        --with-stream_realip_module \
        --with-stream_geoip_module=dynamic \
        --with-http_slice_module \
        --with-mail \
        --with-mail_ssl_module \
        --with-compat \
        --with-file-aio \
        --with-http_v2_module \
        --with-pcre=/usr/src/pcre-$PCRE_VERSION \
        --with-zlib=/usr/src/zlib-$ZLIB_VERSION \
        --with-openssl=/usr/src/openssl-OpenSSL_$OPENSSL_VERSION \
        --add-module=/usr/src/nginx-ct-$NGINX_CT_VERSION \
        --add-module=/usr/src/ngx_http_google_filter_module \
        --add-module=/usr/src/ngx_http_substitutions_filter_module \
    " \
    && addgroup -S nginx \
    && adduser -D -S -h /var/cache/nginx -s /sbin/nologin -G nginx nginx \
    && apk add --no-cache ca-certificates \
    && apk add --no-cache --virtual .build-deps \
        gcc \
        libc-dev \
        make \
        linux-headers \
        curl \
        gnupg \
        libxslt-dev \
        gd-dev \
        geoip-dev \
        git \
        patch \
        build-base \
        perl-dev \
    && curl -fSL https://ftp.pcre.org/pub/pcre/pcre-$PCRE_VERSION.tar.gz -o pcre.tar.gz \
    && curl -fSL https://zlib.net/zlib-$ZLIB_VERSION.tar.gz -o zlib.tar.gz \
    && curl -fSL https://github.com/openssl/openssl/archive/OpenSSL_$OPENSSL_VERSION.tar.gz -o openssl.tar.gz \
    && curl -fSL https://github.com/grahamedgecombe/nginx-ct/archive/v$NGINX_CT_VERSION.tar.gz -o nginx-ct.tar.gz \
    && curl -fSL http://nginx.org/download/nginx-$NGINX_VERSION.tar.gz -o nginx.tar.gz \
    && curl -fSL http://nginx.org/download/nginx-$NGINX_VERSION.tar.gz.asc  -o nginx.tar.gz.asc \
    && export GNUPGHOME="$(mktemp -d)" \
    && found=''; \
    for server in \
        ha.pool.sks-keyservers.net \
        hkp://keyserver.ubuntu.com:80 \
        hkp://p80.pool.sks-keyservers.net:80 \
        pgp.mit.edu \
    ; do \
        echo "Fetching GPG key $GPG_KEYS from $server"; \
        gpg --keyserver "$server" --keyserver-options timeout=10 --recv-keys "$GPG_KEYS" && found=yes && break; \
    done; \
    test -z "$found" && echo >&2 "error: failed to fetch GPG key $GPG_KEYS" && exit 1; \
    gpg --batch --verify nginx.tar.gz.asc nginx.tar.gz \
    && rm -r "$GNUPGHOME" nginx.tar.gz.asc \
    && mkdir -p /usr/src \
    && tar -zxC /usr/src -f pcre.tar.gz \
    && tar -zxC /usr/src -f zlib.tar.gz \
    && tar -zxC /usr/src -f openssl.tar.gz \
    && tar -zxC /usr/src -f nginx-ct.tar.gz \
    && tar -zxC /usr/src -f nginx.tar.gz \
    && rm pcre.tar.gz \
    && rm zlib.tar.gz \
    && rm openssl.tar.gz \
    && rm nginx-ct.tar.gz \
    && rm nginx.tar.gz \
    && cd /usr/src \
    && git clone https://github.com/cloudflare/sslconfig.git \
    && git clone https://github.com/yaoweibin/ngx_http_substitutions_filter_module.git \
    && git clone https://github.com/cuber/ngx_http_google_filter_module.git \
    && cd /usr/src/openssl-OpenSSL_$OPENSSL_VERSION \
    && patch -p1 < /usr/src/sslconfig/patches/openssl__chacha20_poly1305_draft_and_rfc_ossl102j.patch \
    && cd /usr/src/nginx-$NGINX_VERSION \
    && ./configure $CONFIG --with-debug \
    && make -j$(getconf _NPROCESSORS_ONLN) \
    && mv objs/nginx objs/nginx-debug \
    && mv objs/ngx_http_xslt_filter_module.so objs/ngx_http_xslt_filter_module-debug.so \
    && mv objs/ngx_http_image_filter_module.so objs/ngx_http_image_filter_module-debug.so \
    && mv objs/ngx_http_geoip_module.so objs/ngx_http_geoip_module-debug.so \
    && mv objs/ngx_stream_geoip_module.so objs/ngx_stream_geoip_module-debug.so \
    && ./configure $CONFIG \
    && make -j$(getconf _NPROCESSORS_ONLN) \
    && make install \
    && rm -rf /etc/nginx/html/ \
    && mkdir /etc/nginx/conf.d/ \
    && mkdir -p /usr/share/nginx/html/ \
    && install -m644 html/index.html /usr/share/nginx/html/ \
    && install -m644 html/50x.html /usr/share/nginx/html/ \
    && install -m755 objs/nginx-debug /usr/sbin/nginx-debug \
    && install -m755 objs/ngx_http_xslt_filter_module-debug.so /usr/lib/nginx/modules/ngx_http_xslt_filter_module-debug.so \
    && install -m755 objs/ngx_http_image_filter_module-debug.so /usr/lib/nginx/modules/ngx_http_image_filter_module-debug.so \
    && install -m755 objs/ngx_http_geoip_module-debug.so /usr/lib/nginx/modules/ngx_http_geoip_module-debug.so \
    && install -m755 objs/ngx_stream_geoip_module-debug.so /usr/lib/nginx/modules/ngx_stream_geoip_module-debug.so \
    && ln -s ../../usr/lib/nginx/modules /etc/nginx/modules \
    && strip /usr/sbin/nginx* \
    && strip /usr/lib/nginx/modules/*.so \
    && rm -rf /usr/src/pcre-$PCRE_VERSION \
    && rm -rf /usr/src/zlib-$ZLIB_VERSION \
    && rm -rf /usr/src/openssl-OpenSSL_$OPENSSL_VERSION \
    && rm -rf /usr/src/nginx-ct-$NGINX_CT_VERSION \
    && rm -rf /usr/src/ngx_http_google_filter_module \
    && rm -rf /usr/src/ngx_http_substitutions_filter_module \
    && rm -rf /usr/src/nginx-$NGINX_VERSION \
    \
    # Bring in gettext so we can get `envsubst`, then throw
    # the rest away. To do this, we need to install `gettext`
    # then move `envsubst` out of the way so `gettext` can
    # be deleted completely, then move `envsubst` back.
    && apk add --no-cache --virtual .gettext gettext \
    && mv /usr/bin/envsubst /tmp/ \
    \
    && runDeps="$( \
        scanelf --needed --nobanner --format '%n#p' /usr/sbin/nginx /usr/lib/nginx/modules/*.so /tmp/envsubst \
            | tr ',' '\n' \
            | sort -u \
            | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
    )" \
    && apk add --no-cache --virtual .nginx-rundeps $runDeps \
    && apk del .build-deps \
    && apk del .gettext \
    && mv /tmp/envsubst /usr/local/bin/ \
    \
    # forward request and error logs to docker log collector
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

COPY nginx /etc/nginx/

RUN nginx -t

EXPOSE 80 443

STOPSIGNAL SIGTERM

CMD ["nginx", "-g", "daemon off;"]
