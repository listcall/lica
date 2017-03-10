// Note: You must restart bin/webpack-watcher for changes to take effect

const webpack = require('webpack')
const merge = require('webpack-merge')

const sharedConfig = require('./shared.js')

module.exports = merge(sharedConfig.config, {
  devtool: 'sourcemap',

  stats: {
    errorDetails: false,
    noInfo: false,
    hash: false,
    version: false,
    chunks: false,
    assets: false,
    warnings: false,
    modules: false
  },

  output: {
    pathinfo: true
  },

  plugins: [
    new webpack.LoaderOptionsPlugin({
      debug: true
    })
  ]
})
