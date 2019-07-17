# OneMirror

[![](https://images.microbadger.com/badges/image/bohan/onemirror.svg)](https://hub.docker.com/r/bohan/onemirror)

OneMirror is a Docker image for nginx with already configured Google Search proxy. 

## Warning!!!

This project is under maintenance-only mode, it is not actively supported, mainly because [ngx_http_google_filter_module](https://github.com/cuber/ngx_http_google_filter_module), the foundation of Google proxy feature, doesn't support latest version of nginx.

We recommend that you should look through the nginx config files before start using it, and also please adjust them as you need.

因为实现 Google 反代的模块 [ngx_http_google_filter_module](https://github.com/cuber/ngx_http_google_filter_module) 不支持最新版本的 nginx，所以我们不会积极地维护这个项目。

我们建议您使用前浏览一遍 nginx 配置文件，并根据需要修改。

## Info

 * Revised on the basis of [the official nginx Dockerfile](https://github.com/nginxinc/docker-nginx/blob/2364fdc54af554d28ef95b7be381677d10987986/stable/alpine/Dockerfile)
 * nginx 1.14.2
 * Google Search proxy feature with [ngx_http_google_filter_module](https://github.com/cuber/ngx_http_google_filter_module/tree/5806afeffe0a773f70f6aa8ef509b9f118ef6c2c)
 * Brotli compression with [ngx_brotli](https://github.com/eustas/ngx_brotli)

## Usage

### Basic HTTP Mirror for Google Search

    docker run -p 80:80 bohan/onemirror

### Google Fonts, Gravatar, CDNJS & Launchpad PPA Mirror

    docker run -p 80:8080 bohan/onemirror
    
### Custom Configuration and SSL

Put your configuration files inside the `nginx` folder and then re-build it.

## License

MIT
