process.env.NODE_ENV = process.env.NODE_ENV || 'development'

const environment = require('./environment')
const BundleAnalyzerPlugin = require('webpack-bundle-analyzer').BundleAnalyzerPlugin;

const resolver = {
  plugins: [
    // new BundleAnalyzerPlugin()
  ]
}

environment.config.merge(resolver)
module.exports = environment.toWebpackConfig()
