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
    filename: 'meshblu-http.bundle.uncompressed.js'
  },
  module: {
    loaders: [
      { test: /\.coffee$/, loader: "coffee" }
    ]
  },
  plugins: [
     new CompressionPlugin({
       asset: 'schema-transmogrifier.bundle.js'
     })
   ]
};
