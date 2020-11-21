require 'erb'
require 'cgi'

erb = ERB.new(File.read("./sample_code.html.erb"))
html = erb.result(binding)

cgi = CGI.new
puts cgi.header
puts html
