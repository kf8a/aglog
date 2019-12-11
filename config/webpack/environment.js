const { environment } = require('@rails/webpacker')
const elm =  require('./loaders/elm')

const webpack = require('webpack');
environment.plugins.append('Provide', new webpack.ProvidePlugin({
  $: 'jquery',
  jQuery: 'jquery',
  Popper: ['popper.js', 'default']
}));


environment.loaders.prepend('elm', elm)
module.exports = environment
