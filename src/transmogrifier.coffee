async     = require 'async'
deref     = require 'json-schema-deref'
OldSchema = require './old-schema'
V1Schema = require './v1-schema'

class Transmogrifier
  constructor: ({ device, schemaType }) ->
    @oldSchema = new OldSchema { device, schemaType }
    @v1Schema = new V1Schema { device, schemaType }

  convert: (callback) =>
    @getRawSchemas (error, response) =>
      return callback error if error?
      return callback null unless response?
      async.parallel {
        schema: async.apply(@deref, response.schema)
        form: async.apply(@deref, response.form)
      }, callback

  deref: (schema, callback) =>
    return callback() unless schema?
    deref(schema, callback)

  getRawSchemas: (callback) =>
    return @oldSchema.getSchemas(callback) if @oldSchema.is()
    return @v1Schema.getSchemas(callback) if @v1Schema.is()
    callback null

module.exports = Transmogrifier
