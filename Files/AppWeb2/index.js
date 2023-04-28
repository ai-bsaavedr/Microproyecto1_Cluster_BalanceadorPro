const Consul = require('consul');
const express = require('express');

const SERVICE_NAME='microservicioWeb2';
const SERVICE_ID='m'+process.argv[2];
const SCHEME='http';
const HOST='192.168.100.11';
const PORT=process.argv[2]*1;

/* Inicializamos server */
const app = express();
const consul = new Consul();

app.get('/health', function (req, res) {
    console.log('Health check!');
    res.end( "Ok." );
    });

app.get('/', function (req, res) {
    const s='<h1>Instancia '+ SERVICE_ID+ ' del servicio ' + SERVICE_NAME+ ' </h1><style>body {font-family: Arial, sans-serif;background-color: #f2f2f2;}h1 {            color: #ff6347;            text-align: center;            margin-top: 50px;        }        p {            font-size: 18px;            line-height: 1.5;            text-align: center;            margin-top: 20px;            margin-bottom: 50px;        }    </style>';

    res.send(s);
    });
 
app.listen(PORT, function () {
    console.log('Sistema armado en el puerto '+SCHEME+'://'+HOST+':'+PORT+'!');
    });

/* Registro del servicio */
var check = {
  id: SERVICE_ID,
  name: SERVICE_NAME,
  address: HOST,
  port: PORT, 
  check: {
	   http: SCHEME+'://'+HOST+':'+PORT+'/health',
	   ttl: '5s',
	   interval: '5s',
     timeout: '5s',
     deregistercriticalserviceafter: '1m'
	   }
  };
 
consul.agent.service.register(check, function(err) {
  	if (err) throw err;
  	});