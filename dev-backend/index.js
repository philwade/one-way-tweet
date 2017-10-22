"use strict";

var express = require('express'),
	cookieParser = require('cookie-parser'),
	config = require('./config.json'),
	Twitter = require('node-twitter-api'),
	secret = require('./secret.json');

var twitter = new Twitter({
	consumerKey: secret.twitter.consumerKey,
	consumerSecret: secret.twitter.consumerSecret,
	callback: secret.twitter.callbackUrl
});

var app = express();
app.use(cookieParser());

var _accessToken,
	_requestSecrets = {}, // keyed against requestTokens
	_accessSecret;

app.get("/request-auth", function(req, res) {
	twitter.getRequestToken(function(err, requestToken, requestSecret) {
		if (err)
			res.status(500).send(err);
		else {
			console.log("requestToken", requestToken);
			_requestSecrets[requestToken] = requestSecret;
			res.send("https://api.twitter.com/oauth/authenticate?oauth_token=" + requestToken);
		}
	});
});

app.get("/request-token", function(req, res) {
	var requestToken = req.query.oauth_token,
		requestSecret = _requestSecrets[requestToken],
		verifier = req.query.oauth_verifier;

	console.log("requestToken in /request-token", requestToken);
	twitter.getAccessToken(requestToken, requestSecret, verifier, function(err, accessToken, accessSecret) {
		if (err)
			res.status(500).send(err);
		else
			twitter.verifyCredentials(accessToken, accessSecret, function(err, user) {
				if (err) {
					res.status(500).send(err);
				} else {
					console.log("accessToken", accessToken);
					console.log("accessSecret", accessSecret);
					_accessToken = accessToken;
					_accessSecret = accessSecret;
					res.cookie("accessToken", accessToken);
					res.cookie("accessSecret", accessSecret);
					res.send(user);
				}
			});
	});
});

app.get("/post-status", function(req, res) {
	var statusContent = req.query.status;

	twitter.statuses("update", {
			status: statusContent
		},
		_accessToken,
		_accessSecret,
		function(error, data, response) {
			if (error) {
				// something went wrong
			} else {
				// data contains the data sent by twitter
			}
		}
	);

});

app.listen(config.server.port, function () {
	console.log("Listening on " + config.server.port + "...");
});
