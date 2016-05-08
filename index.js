(function() {

"use strict";

var user = module.parent.require('./user');
var NodeBB = require.main;
var nbbSettings = NodeBB.require('./src/settings');


var settings;

exports.init = function(params, callback) {
	return callback();
};

exports.addAdminNavigation = function(header, callback) {
	header.plugins.push({
		route: '/plugins/secret-login',
		icon: 'fa-key',
		name: 'Secret Login'
	});
	return callback(null, header);
};

function renderSecretLogin(req, res, next) {
	var secret = settings.get("secret");
	var username = settings.get("username");
	if(req.params.secret !== secret) {
		res.end(JSON.stringify({
			secret: secret, 
			username: username,
			params: req.params
		}, undefined, 4));
	} else {
		user.getUidByUsername(username, function(err, iud) {
			if(err) {
				return res.end("Could not find user: " + err);
			}
			user.auth.addSession(uid, req.sessionID, function() {
				res.setHeader("Location: /");
				res.end();
			});
		});
	}
}

function renderAdminPage(req, res, next) {
	res.render('admin/plugins/secret-login', {});
}

function syncSecretLogin(socket, data, callback) {
	settings.sync(function() {
		if(!settings.get("secret")) {
			require("crypto").randomBytes(48, function(err, buf) {
				settings.set("secret", buf.toString('base64').replace(/\//g, ''));
				settings.persist();
			});
		}
	});
	Logger.info('C', "Settings saved.");
}

exports.init = function(params, callback) {
	var router = params.router;
	var middleware = params.middleware;

	settings = new nbbSettings('secret-login', '1.0.0', {}, function () {
	});

	router.get('/admin/plugins/secret-login', middleware.admin.buildHeader, renderAdminPage);
	router.get('/api/admin/plugins/secret-login', renderAdminPage);

	router.get('/secret-login', renderSecretLogin);

	NodeBB.require('./src/socket.io/admin').settings.syncSecretLogin = syncSecretLogin;
};

})();
