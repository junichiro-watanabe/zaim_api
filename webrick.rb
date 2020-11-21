require 'webrick'

server = WEBrick::HTTPServer.new({
  DocumentRoot:   './',
  BindAddress:    '0.0.0.0',
  CGIInterpreter: '/usr/local/bin/ruby',
  Port:           3000
})

server.mount('/', WEBrick::HTTPServlet::CGIHandler, 'sample_code.rb')

server.start
