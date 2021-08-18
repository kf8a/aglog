const { environment } = require('@rails/webpacker')
const elm =  require('./loaders/elm')
const webpack = require('webpack')

environment.plugins.append('Provide', new webpack.ProvidePlugin({
  $: 'jquery',
  jQuery: 'jquery',
  Popper: ['popper.js', 'default']
}));

// const config = environment.toWebpackConfig();
//
// config.resolve.alias = {
//  jquery: 'jquery/src/jquery'
// };

environment.loaders.prepend('elm', elm)
module.exports = environment
