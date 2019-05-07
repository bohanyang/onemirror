# OneMirror

[![](https://images.microbadger.com/badges/image/bohan/onemirror.svg)](https://hub.docker.com/r/bohan/onemirror)

OneMirror is a Docker image for nginx with already configured Google Search proxy. 

## Info

 * Revised on the basis of [the official nginx Dockerfile](https://github.com/nginxinc/docker-nginx/blob/2364fdc54af554d28ef95b7be381677d10987986/stable/alpine/Dockerfile)
 * nginx 1.14.2
 * Added [ngx_http_google_filter_module](https://github.com/cuber/ngx_http_google_filter_module)

## Usage

### Basic HTTP Mirror for Google Search

    $ docker run -p 9009:80 -d bohan/onemirror
    
### Custom Configuration and SSL

Put your configuration files inside the `nginx` folder and then re-build it.

## License

MIT
