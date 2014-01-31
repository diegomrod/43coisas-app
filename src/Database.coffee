EventEmitter = require('events').EventEmitter
mysql = require('mysql')

Database = new EventEmitter()

# Faz a conexão ao banco de dados
Database.on('conectar', (callback) ->
  conn = mysql.createConnection(
    "host" : DB_HOST
    "user" : DB_USER
    "password" : DB_PASS
    "database" : DB_NAME
  )
  conn.connect()
  callback(conn)
)

# Insere uma query no banco de dados 
Database.on('inserirQuery', (conn, query, callback) ->
  conn.query(query, (err, rows, fields) ->
    if err then throw err
    callback(rows)
  )
)

# Retorna todas as coisas cadastradas
Database.on('/table/coisas/all', (callback) ->
  Database.emit('conectar', (conn) ->
    query = "SELECT * FROM `#{TABLE_COISAS}` WHERE 1;"
    Database.emit('inserirQuery', conn, query, (rows, fields) ->
      callback(rows)
      conn.end()
    )
  )
)

# Retorna 43 coisas organizadas de maneira decrescente
Database.on('/table/coisas/mais-citadas', (callback) ->
  Database.emit('conectar', (conn) ->
    query = "SELECT `id`, `coisa`, `vezes_citada` FROM `#{TABLE_COISAS}` ORDER BY `vezes_citada` DESC LIMIT 0, 42;"
    Database.emit('inserirQuery', conn, query, (rows, fields) ->
      callback(rows)
      conn.end()
    )
  )
)

# Retorna uma coisa pelo id
Database.on('/table/coisas/id', (id, callback) ->
  Database.emit('conectar', (conn) ->
    query = "SELECT * FROM `#{TABLE_COISAS}` WHERE `id` = #{id};"
    Database.emit('inserirQuery', conn, query, (rows, fields) ->
      callback(rows)
      conn.end()
    )
  )
)

# Insere uma coisa no banco de dados
Database.on('/table/coisas/insert', (obj) ->
  Database.emit('conectar', (conn) ->
    Database.emit('/table/coisas/search/iguais', obj.coisa, () ->
      Database.emit('/table/coisas/update/add', obj.coisa)
    , ()->
      query = "INSERT INTO `#{TABLE_COISAS}` VALUES('', '#{obj.coisa}', '1', NOW(), NOW(), '#{obj.user || ''}');"
      Database.emit('inserirQuery', conn, query, (rows, fields) ->
        conn.end()
      )
    )
  )
)

# Define se uma coisa já está cadastrada no banco de dados
Database.on('/table/coisas/search/iguais', (coisa, fn_yes, fn_no) ->
  Database.emit('conectar', (conn) ->
    query = "SELECT `coisa` FROM `#{TABLE_COISAS}` WHERE `coisa`='#{coisa}';"
    Database.emit('inserirQuery', conn, query, (rows, fields) ->
      if rows.length > 0 then fn_yes() else fn_no()
      conn.end()
    )
  )
)

# Obtem a quantidade de vezes que uma coisa foi citada
Database.on('/table/coisas/search/vezes-citada', (coisa, callback) ->
  Database.emit('conectar', (conn) ->
    query = "SELECT `vezes_citada` FROM `#{TABLE_COISAS}` WHERE `coisa`='#{coisa}';"
    Database.emit('inserirQuery', conn, query, (rows, fields) ->
      callback(rows[0]['vezes_citada'])
      conn.end()
    )
  )
)

# Adiciona uma mençao para uma coisa já cadastrada no banco de dados
Database.on('/table/coisas/update/add', (coisa) ->
  Database.emit('/table/coisas/search/vezes-citada', coisa, (vezes_citada) ->
    Database.emit('conectar', (conn) ->
      temp = parseInt(vezes_citada, 10)
      query = "UPDATE `#{TABLE_COISAS}` SET `vezes_citada`='#{temp += 1}' WHERE `coisa`='#{coisa}';"
      Database.emit('inserirQuery', conn, query, (rows, fields) ->
        conn.end()
      )
    )
  )
)

module.exports = Database
