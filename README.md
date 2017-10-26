# OneMirror

OneMirror is a Docker image of NGINX. With already configured Google Search, Google Fonts/Icons, CDNJS and Gravatar proxy, it helps you to start your own mirror site easily.

## Info

 - Dockerfile derived from official NGINX Docker (Alpine) Image
 - Latest mainline version NGINX
 - Latest OpenSSL 1.0.2 with CloudFlare's CHACHA20 patch
 - Google Search mirror module `ngx_http_google_filter_module` added
 - Certificate Transparency with TLS extension supported
 - With Google Search, Google Fonts/Icons, CDNJS and Gravatar proxy configuration example

## Usage

### Basic HTTP Mirror for Google Search

    $ docker run -p 4664:80 -d bohan/onemirror
    
### Custom Configuration and SSL

 - You can use your own nginx.conf,
 - and your own site configuartions at nginx/conf.d,
 - and also enable SSL (Please read `nginx/ssl/README.txt`)
 - Build it 
 - `$ docker build -t onemirror .`
 - and use it
 - `$ docker run -p 4664:443 -d onemirror`

### Known Issues

 - Mirror of Google Scholar may not working

## License

MIT
