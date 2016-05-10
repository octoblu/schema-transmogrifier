var path              = require('path');
var webpack           = require('webpack');
var CompressionPlugin = require("compression-webpack-plugin");

module.exports = {
  entry: [
    './src/transmogrifier.coffee'
  ],
  output: {
    library: 'SchemaTransmogrifier',
    path: path.join(__dirname, 'deploy', 'schema-transmogrifier', 'latest'),
    filename: 'schema-transmogrifier.bundle.uncompressed.js'
  },
  module: {
    loaders: [
      { test: /\.coffee$/, loader: "coffee" },
      { test: /\.json$/, loader: "json" }
    ]
  },
  plugins: [
     new CompressionPlugin({
       asset: 'schema-transmogrifier.bundle.js'
     })
   ],
   "node": {
     "fs": "empty",
     "net": "empty",
     "tls": "empty"
   }
};
