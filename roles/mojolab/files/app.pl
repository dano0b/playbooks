#!/usr/bin/env perl
use utf8;
use Mojolicious::Lite;
use Mojo::IOLoop;
use DateTime;

get '/' => 'index';

my $clients = {};

websocket '/echo' => sub {
    my $self = shift;

    app->log->debug(sprintf 'Client connected: %s', $self->tx);
    my $id = sprintf "%s", $self->tx;
    $clients->{$id} = $self->tx;

    Mojo::IOLoop->recurring(2 => sub {
        my $loop = shift;
        my $dt   = DateTime->now( time_zone => 'Europe/Berlin');
        for (keys %$clients) {
            $clients->{$_}->send({json => {
                hms  => $dt->hms,
            }});
        }
    });
};

app->start;

__DATA__
@@ index.html.ep
<html>
  <head>
    <title>WebSocket Test</title>
    <script
      type="text/javascript"
      src="http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js">
    </script>
    <script type="text/javascript" src="http://localhost/js/ws.js"></script>
    <style type="text/css">
      textarea {
          width: 40em;
          height:10em;
      }
    </style>
  </head>
<body>

<h1>Mojolicious + WebSocket</h1>

<textarea id="log" readonly></textarea>

</body>
</html>
