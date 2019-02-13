# OneMirror

OneMirror is a Docker image of NGINX. With already configured Google Search proxy, it helps you to start your own mirror site easily.

Thanks to Alpine Linux, the image size is only ~16 MB. 

## Info

 * Dockerfile derived from official NGINX Docker (Alpine Linux 3.9) image
 * 1.14.x version of NGINX
 * Google Search mirror module `ngx_http_google_filter_module` added
 * With Google Search proxy configuration example

## Usage

### Basic HTTP Mirror for Google Search

    $ docker run -p 4664:80 -d bohan/onemirror
    
### Custom Configuration and SSL

Put your configuration files inside the `nginx` folder and then re-build it.

## To-do List

 * Re-add CDNJS, Google Ajax/Fonts/Icons, Gravatar, polyfill.io Proxy Configuration
 * Simple Guide/Wiki/Documentation for Custom Configuration and SSL

## License

MIT
