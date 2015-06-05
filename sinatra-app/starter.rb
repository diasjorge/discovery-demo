require 'open-uri'
require 'json'

info = open("http://#{ENV.fetch('CONSUL_HOST', 'consul.service.consul')}:8500/v1/catalog/service/redis").read

ENV['REDIS_HOST'] = JSON.parse(info).first["Address"].to_s
ENV['REDIS_PORT'] = JSON.parse(info).first["ServicePort"].to_s

`ruby app.rb`
