
vcl 4.0;
 
backend default {
    .host = "127.0.0.1";
    .port = "80";
}

sub vcl_init {
    # Set the malloc parameter
    malloc 128M
    
    # Set the file_combine parameter
    file_combine 8K
}
 
sub vcl_recv {
    if (req.url ~ "^/images/") {
        unset req.http.cookie;
    }
 
    # Normalize the Accept-Encoding header
    if (req.http.Accept-Encoding) {
        if (req.http.Accept-Encoding ~ "gzip") {
            set req.http.Accept-Encoding = "gzip";
        } else if (req.http.Accept-Encoding ~ "deflate") {
            set req.http.Accept-Encoding = "deflate";
        } else {
            unset req.http.Accept-Encoding;
        }
    }
}

sub vcl_backend_response {
    # Remove Vary header if content is static
    if (bereq.url ~ "(?i)\.(png|gif|jpg|css|js)$") {
        unset beresp.http.Vary;
    }
 
    # Store Varnish Cache-Control & Expires headers
    set beresp.http.X-Varnish-Expires = beresp.http.Cache-Control;
    unset beresp.http.Cache-Control;
}

sub vcl_deliver {
    # Restore Varnish Cache-Control & Expires headers
    if (resp.http.X-Varnish-Expires) {
        set resp.http.Cache-Control = resp.http.X-Varnish-Expires;
        unset resp.http.X-Varnish-Expires;
    }
}
