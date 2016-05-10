var path              = require('path');
var webpack           = require('webpack');

module.exports = {
  devtool: 'cheap-module-source-map',
  entry: [
    './src/transmogrifier.coffee'
  ],
  output: {
    library: 'SchemaTransmogrifier',
    path: path.join(__dirname, 'deploy', 'schema-transmogrifier', 'latest'),
    filename: 'schema-transmogrifier.bundle.js'
  },
  module: {
    loaders: [
      { test: /\.js$/, loader: 'babel' },
      { test: /\.coffee$/, loader: "coffee" },
      { test: /\.json$/, loader: "json" }
    ]
  },
  plugins: [
    new webpack.DefinePlugin({
      'process.env': {
        'NODE_ENV': JSON.stringify('production')
      }
    }),
    new webpack.NoErrorsPlugin(),
    new webpack.optimize.UglifyJsPlugin({
      compress: {
        warnings: false
      }
    })
  ],
  "node": {
    "fs": "empty"
  }
};
