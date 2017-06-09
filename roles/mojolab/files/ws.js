$(function () {
  $('#msg').focus();

  var log = function (text) {
    $('#log').val( $('#log').val() + text + "\n");
  };
  
  var ws = new WebSocket('ws://localhost:8080/echo');
  ws.onopen = function () {
    log('Connection opened');
  };
  
  ws.onmessage = function (msg) {
    var res = JSON.parse(msg.data);
    log('just a simple pushed date: ' + res.hms ); 
  };

$('#msg').keydown(function (e) {
    if (e.keyCode == 13 && $('#msg').val()) {
        ws.send($('#msg').val());
        $('#msg').val('');
    }
  });
});
