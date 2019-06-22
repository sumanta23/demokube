var express    = require('express');
var http       = require('http');
var bodyParser = require('body-parser');
var Redis      = require('ioredis');

const tracing = require('@opencensus/nodejs');
const propagation = require('@opencensus/propagation-b3');
const b3 = new propagation.B3Format();

tracing.start({
    propagation: b3,
    samplingRate: 1.0
});


var app = express();
var server = http.createServer(app);

var convar = {
    host : process.env.REDIS_HOST || 'localhost',
    port : 6379
}

var client = new Redis(convar)

app.use(bodyParser.urlencoded({ extended: false }));

app.get('/api/counter',function(req,res){
  console.log(JSON.stringify(req.headers));
  client.incr("counter", (err,resC)=>{
      if(err){
        throw err;
      }else{
        return res.json(resC);
      }
    });  
});

server.listen(process.env.PORT || 5000);
