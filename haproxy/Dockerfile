FROM haproxy:1.5

ADD files/ /

CMD ["consul-template", "-consul", "consul.service.consul:8500", "-template", "/etc/haproxy/haproxy.cfg.ctmpl:/etc/haproxy/haproxy.cfg:haproxy-start"]
