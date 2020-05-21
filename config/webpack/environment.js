const { resolve } = require('path')
const { environment, config } = require('@rails/webpacker')
const rootJavascriptPath = config.source_path

const resolver = {
  resolve: {
    alias: {
      Css: resolve(rootJavascriptPath, 'css')
    }
  }
}

environment.loaders.delete('nodeModules')
environment.config.merge(resolver)

module.exports = environment
