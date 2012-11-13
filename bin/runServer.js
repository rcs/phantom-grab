#!/usr/bin/env coffee
var coffee = require("coffee-script");

var fs = require("fs");
var path = require("path");
var root = path.join(path.dirname(fs.realpathSync(__filename)), "../");
require(root + "server").startServer(process.env.PORT || 3000, root + "public")
