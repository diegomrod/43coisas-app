var debug;
var App = (function ($) {
  'use strict';
  var HOST = "http://localhost:3000";
  var listaDeCoisas = undefined;
  var coisas = [];
  var dom_coisas = [];
  var xhr_coisas = $.get(HOST + "/get/coisas/mais-citadas");
  var min = 0;
  var forms = [];
  
  // Calcula o tamanho da fonte com base no menor valor
  function calcularTamanhoDaFonte (tamanho) {
    return (((tamanho / min) + 12).toFixed(0) + "px");
  };
  
  // Organiza as coisas aleátorias
  function randomListaDeCoisas () {
    return this.sort(function (a, b) {
      if (Math.random() > 0.5)
        return 1;
    });
  };
  
  // Insere as coisas na div :-)
  function inserirCoisasNaDiv () {
    randomListaDeCoisas.call(this);
    
    return this.forEach(function (val, index) {
      listaDeCoisas.append($("<span>")
        .append(val).css("margin", "0px 5px")); 
    });
  };
  
  // Atualiza o app
  function update() {
    var temp = undefined;
    coisas.forEach(function (val, index) {
      temp = $("<a>");
      temp.addClass("43coisas-coisa");
      temp.attr("value", val['id']);
      temp.text(val['coisa']);
      temp.css({
        "font-size" : calcularTamanhoDaFonte(val['vezes_citada'])
      });
      dom_coisas.push(temp);
    });
    
    return inserirCoisasNaDiv.call(dom_coisas);
  };
  
  $(this).on('load', function () {
    listaDeCoisas = $("div#43coisas-coisas div");
    forms = $("form.43coisas-form");
    
    return xhr_coisas.done(function (data) {
      coisas = JSON.parse(data);
      min = coisas[coisas.length - 1]['vezes_citada'];
      update();
    });
  });
  
  $(this).on('load', function () {
    $("#43coisas-button").on('click', function () {
      var temp = {};
      Array.prototype.forEach.call(forms, function (val, index) {
        temp = val.querySelectorAll("input");
        if (temp[1].value !== "" && temp[1].value.length < 65) {
          $.post(HOST + "/post/coisas/new", {
            user  : temp[0].value,
            coisa : temp[1].value
          });
          temp[1].value = "";
        }  
      });
    });
  });
  
}).call(this, jQuery);
