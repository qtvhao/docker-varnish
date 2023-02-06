FROM public.ecr.aws/docker/library/varnish:7.2

COPY default.vcl /etc/varnish/
