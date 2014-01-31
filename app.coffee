http = require('http')
Route = require('./src/Route.coffee')
qs = require("querystring")

# Informações do app
GLOBAL.NOME = "43coisas"
GLOBAL.VERSION = "0.0.1"
GLOBAL.HOST = "localhost"
GLOBAL.PORT = 3000

# Informações do Banco de Dados
GLOBAL.DB_HOST = "localhost"
GLOBAL.DB_USER = "root"
GLOBAL.DB_PASS = process.argv[3] || ""
GLOBAL.DB_NAME = "wordpress_db"

# Tabelas do aplicativo
GLOBAL.TABLE_COISAS = "wp_43coisas_coisas"

app = http.createServer().listen(PORT, ()->
  console.log("App listening on port #{PORT}")
)

# Request handler
app.on('request', (req, res) ->
  res.setHeader('Access-Control-Allow-Origin', '*')
  if req.method is 'GET'
    Route.emit('redirecionar-get', req, res)
  else
    body = undefined
    req.on('data', (data) ->
      body += data
      Route.emit('redirecionar-post', qs.parse(body), req, res)
    )
  console.log("Request : #{req.url}")
)
