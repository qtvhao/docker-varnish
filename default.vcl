vcl 4.1;

backend default none;
import dynamic;

# set up a dynamic director
# for more info, see https://github.com/nigoroll/libvmod-dynamic/blob/master/src/vmod_dynamic.vcc
sub vcl_init {
        new d = dynamic.director(port = "80");
}

sub vcl_recv {
    set req.backend_hint = d.backend(req.http.host);
}

sub vcl_backend_response {
    set beresp.ttl = 1h;
}
