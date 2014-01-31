// Generated by CoffeeScript 1.4.0
(function() {
  var Route, app, http, qs;

  http = require('http');

  Route = require('./bin/Route.js');

  qs = require("querystring");

  GLOBAL.NOME = "43coisas";

  GLOBAL.VERSION = "0.0.1";

  GLOBAL.HOST = "localhost";

  GLOBAL.PORT = 3000;

  GLOBAL.DB_HOST = "localhost";

  GLOBAL.DB_USER = "root";

  GLOBAL.DB_PASS = process.argv[3] || "";

  GLOBAL.DB_NAME = "wordpress_db";

  GLOBAL.TABLE_COISAS = "wp_43coisas_coisas";

  app = http.createServer().listen(PORT, function() {
    return console.log("App listening on port " + PORT);
  });

  app.on('request', function(req, res) {
    var body;
    res.setHeader('Access-Control-Allow-Origin', '*');
    if (req.method === 'GET') {
      Route.emit('redirecionar-get', req, res);
    } else {
      body = void 0;
      req.on('data', function(data) {
        body += data;
        return Route.emit('redirecionar-post', qs.parse(body), req, res);
      });
    }
    return console.log("Request : " + req.url);
  });

}).call(this);
