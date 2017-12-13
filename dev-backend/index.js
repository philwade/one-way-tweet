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

var _requestSecrets = {}; // keyed against requestTokens

app.get("/request-auth", function(req, res) {
	twitter.getRequestToken(function(err, requestToken, requestSecret) {
		if (err)
			res.status(500).send(err);
		else {
			_requestSecrets[requestToken] = requestSecret;
			res.send("https://api.twitter.com/oauth/authenticate?oauth_token=" + requestToken);
		}
	});
});

app.get("/request-token", function(req, res) {
	var requestToken = req.query.oauth_token,
		requestSecret = _requestSecrets[requestToken],
		verifier = req.query.oauth_verifier;

	twitter.getAccessToken(requestToken, requestSecret, verifier, function(err, accessToken, accessSecret) {
		if (err)
			res.status(500).send(err);
		else
			twitter.verifyCredentials(accessToken, accessSecret, function(err, user) {
				if (err) {
					res.status(500).send(err);
				} else {
					res.cookie("accessToken", accessToken);
					res.cookie("accessSecret", accessSecret);
					res.send(user);
				}
			});
	});
});

app.get("/post-status", function(req, res) {
	console.log(req);
	var statusContent = req.query.status,
		accessToken = req.cookies.accessToken,
		accessSecret = req.cookies.accessSecret;

	twitter.statuses("update", {
			status: statusContent
		},
		accessToken,
		accessSecret,
		function(error, data, response) {
			if (error) {
				console.log(error);
				// something went wrong
			} else {
				// data contains the data sent by twitter
				res.send(data);
			}
		}
	);

});

app.get("/get-user", function(req, res) {
	var accessToken = req.cookies.accessToken,
		accessSecret = req.cookies.accessSecret;

	twitter.verifyCredentials(accessToken, accessSecret, function(err, user) {
		if (err) {
			res.status(500).send(err);
		} else {
			res.send(user);
		}
	});
});

app.listen(config.server.port, function () {
	console.log("Listening on " + config.server.port + "...");
});
