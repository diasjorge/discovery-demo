require 'sinatra'
require 'pp'

get '/' do
  res = ""
  res << "Hello from " << `hostname` << "<br/>"
  ENV.each_with_object(res) { |(k,v), str| str << "#{k}: #{v}<br/>" }
  res
end
