"use strict";

var express = require('express'),
	config = require('./config.json'),
	Twitter = require('node-twitter-api'),
	secret = require('./secret.json');

var twitter = new Twitter({
	consumerKey: secret.twitter.consumerKey,
	consumerSecret: secret.twitter.consumerSecret,
	callback: secret.twitter.callbackUrl
});

var app = express();

var _requestSecret;

app.get("/request-auth", function(req, res) {
	twitter.getRequestToken(function(err, requestToken, requestSecret) {
		console.log(arguments);
		if (err)
			res.status(500).send(err);
		else {
			_requestSecret = requestSecret;
			res.send("https://api.twitter.com/oauth/authenticate?oauth_token=" + requestToken);
		}
	});
});

app.get("/request-token", function(req, res) {
	var requestToken = req.query.oauth_token,
		verifier = req.query.oauth_verifier;

	twitter.getAccessToken(requestToken, _requestSecret, verifier, function(err, accessToken, accessSecret) {
		if (err)
			res.status(500).send(err);
		else
			twitter.verifyCredentials(accessToken, accessSecret, function(err, user) {
				if (err)
					res.status(500).send(err);
				else
					res.send(user);
			});
	});
});

app.listen(config.server.port, function () {
	console.log("Listening on " + config.server.port + "...");
});
