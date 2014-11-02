require('coffee-script/register');

var mongoose = require('mongoose');
var express = require('express');
var path = require('path');
var favicon = require('serve-favicon');
var logger = require('morgan');
var cookieParser = require('cookie-parser');
var bodyParser = require('body-parser');
var multer = require('multer');

// Models
require('./models/Signature');
require('./models/Submission');
require('./models/User');

// Routes
var user = require('./routes/user');
var submission = require('./routes/submission');

var app = express();

// view engine setup
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'ejs');

// app.use(favicon(__dirname + '/public/img/favicon.ico'));
app.use(logger('dev'));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({
  extended: true
}));
app.use(multer({
  dest: './static/images/'
}))
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));

app.get('/api/user/:id', user);
app.post('/api/user/create', user);
app.get('/api/user/:id/submission', submission);
app.post('/api/user/:id/submission/create', submission);
app.get('/api/submission/:id', submission);
app.post('/api/submission/:id/authorize', submission)

/// catch 404 and forward to error handler
app.use(function(req, res, next) {
  var err = new Error('Not Found');
  err.status = 404;
  next(err);
});

/// error handlers

// development error handler
// will print stacktrace
if (app.get('env') === 'development') {
  app.use(function(err, req, res, next) {
    res.status(err.status || 500);
    res.render('error', {
      message: err.message,
      error: err,
      title: 'error'
    });
  });
}

// production error handler
// no stacktraces leaked to user
app.use(function(err, req, res, next) {
  res.status(err.status || 500);
  res.render('error', {
    message: err.message,
    error: {},
    title: 'error'
  });
});


module.exports = app;
