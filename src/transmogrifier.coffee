async     = require 'async'
deref     = require 'json-schema-deref'
OldSchema = require './old-schema'

class Transmogrifier
  constructor: ({ device, schemaType }) ->
    @oldSchema = new OldSchema { device, schemaType }

  convert: (callback) =>
    @getRawSchemas (error, response) =>
      return callback error if error?
      return callback null unless response?
      async.parallel {
        schema: async.apply(@_deref, response.schema)
        form: async.apply(@_deref, response.form)
      }, callback

  _deref: (schema, callback) =>
    return callback() unless schema?
    deref(schema, callback)

  getRawSchemas: (callback) =>
    return @oldSchema.getSchemas(callback) if @oldSchema.is()
    callback null

module.exports = Transmogrifier
