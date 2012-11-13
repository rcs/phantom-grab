#!/usr/bin/env coffee

fs = require("fs")
path = require("path")
root = path.join(path.dirname(fs.realpathSync(__filename)), "../")
require(root + "server").startServer process.env.PORT or 3000, root + "public"
