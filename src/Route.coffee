EventEmitter = require('events').EventEmitter
url = require('url')

Database = require('./Database.coffee')

Route = new EventEmitter()

# Erro no request
Route.on('request-erro', (req, res) ->
  res.end("Request : #{req.url} Inválido!")
)

# Retorna as 43 coisas mais citadas
Route.on('/get/coisas/mais-citadas', (query, req, res) ->
  Database.emit('/table/coisas/mais-citadas', (data) ->
    res.end(JSON.stringify(data) || "")
  )
)

# Retorna as informações de uma coisa específica
Route.on('/get/coisas/by-id', (query, req, res) ->
  if query['id']? and !(!parseInt(query['id'], 10))
    Database.emit('/table/coisas/id', query['id'], (data) ->
      res.end(JSON.stringify(data) || "")
    )
  else
    Route.emit('request-erro', req, res)  
)

# Insere uma nova coisa
Route.on('/post/coisas/new', (body, req, res) ->
  if req.method is 'POST'
    if body.coisa and body.coisa.length < 65
      if !body.user or (body.user and body.user.length < 65)
        Database.emit('/table/coisas/insert', body)
        res.end("1")
      else
        res.end("0")
    else    
      res.end("0")   
  else
    Route.emit('request-erro', req, res)  
)

# Retorna um objeto com os valores na query
parseQuery = (query = "") ->
  obj = Object.create({})
  for val in query.split(/\&/)
    aux = val.split("=")
    obj[aux[0]] = aux[1]
  return obj 

# Redireciona o request get
Route.on('redirecionar-get', (req, res) ->
  _url = url.parse(req.url)
  _query = parseQuery(_url.query)

  if _url.pathname isnt '/'
    if !Route.emit(_url.pathname, _query, req, res)
      Route.emit('request-erro', req, res)
  else
    res.end("App 43coisas!")
)

# Redireciona o request post
Route.on('redirecionar-post', (body, req, res) ->
  _url = url.parse(req.url)
  _query = parseQuery(_url.query)
  
  if _url.pathname isnt '/'
    if !Route.emit(_url.pathname, body, req, res)
      Route.emit('request-erro', req, res)
  else
    res.end("App 43coisas!") 
)

module.exports = Route
