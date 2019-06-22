var express    = require('express');
var http       = require('http');
var bodyParser = require('body-parser');
var request    = require("request");

const tracing = require('@opencensus/nodejs');
const propagation = require('@opencensus/propagation-b3');
const b3 = new propagation.B3Format();

tracing.start({
    propagation: b3,
    samplingRate: 1.0
});


var app = express();
var server = http.createServer(app);

app.use(bodyParser.urlencoded({ extended: false }));


console.log("process.env.BACK_END", process.env.BACK_END)

var backend = process.env.BACK_END||"localhost:5000";

var filtered_keys = function(obj, filter) {
  var key, nobj = {};
  for (key in obj) {
    if (obj.hasOwnProperty(key) && filter.test(key)) {
      nobj[key]=obj[key];
    }
  }
  return nobj;
}

app.get('/', function (req, res) {
    console.log(JSON.stringify(req.headers));
    var customheaders = filtered_keys(req.headers, /X-App/i);
    customheaders['User-Agent']= 'request';
    var options = {
        url: "http://"+backend+'/api/counter',
        headers: customheaders
    };
    request(options, function (error, response, body) {
        console.log('error:', error);
        console.log('statusCode:', response && response.statusCode); 
        console.log('body:', body); 
        res.json(body);
    });
});

server.listen(process.env.PORT || 3000);
