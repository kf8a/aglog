const elm =  require('./loaders/elm')
const { environment } = require('@rails/webpacker')

environment.loaders.prepend('elm', elm)
module.exports = environment
