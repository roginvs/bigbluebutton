express = require 'express'
routes  = require './routes'
acodes  = require './lib/accesscodes'
ctrl    = require './lib/controller'
config      = require("./config")
fsproxy = require './routes/proxy'
http    = require 'http'
path    = require 'path'
log     = require './lib/logger'

# Module to store the modules registered in the application
config.modules = modules = new Modules()

app = express()

app.configure(() -> 
  app.set('port', process.env.PORT || 3004);
  app.set('views', __dirname + '/views');
  app.set('view engine', 'ejs');
  app.use(express.favicon());
  app.use(express.logger('dev'));
  app.use(express.bodyParser());
  app.use(express.methodOverride());
  app.use(express.cookieParser('your secret here'));
  app.use(express.session());
  app.use(app.router);
  app.use(express.static(path.join(__dirname, 'public')));
)

app.configure('development', () ->
  app.use(express.errorHandler())
)

controller = new Controller()
ac = new AccessCodes()

app.get('/', routes.index)
app.post('/proxy', fsproxy.dialplan)

http.createServer(app).listen(app.get('port'), () ->
  log.info("Express server listening on port " + app.get('port'));
)
