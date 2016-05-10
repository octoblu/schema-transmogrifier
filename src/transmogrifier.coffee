request   = require 'superagent'
async     = require 'async'
RefParser = require 'json-schema-ref-parser'
OldSchema = require './old-schema.coffee'
V1Schema  = require './v1-schema.coffee'
V2Schema  = require './v2-schema.coffee'

class Transmogrifier
  constructor: ({ device, schemaType }) ->
    throw new Error('Invalid schemaType') unless schemaType in ["configure", "message"]
    @oldSchema = new OldSchema { device, schemaType }
    @v1Schema = new V1Schema { device, schemaType }
    @v2Schema = new V2Schema { device, schemaType }

  convert: (callback) =>
    @getRawSchemas (error, response) =>
      return callback error if error?
      return callback null unless response?
      async.parallel {
        schema: async.apply(@resolveSchemaUrls, response.schema)
        form: async.apply(@resolveSchemaUrls, response.form)
      }, (error, response) =>
        async.parallel {
          schema: async.apply(@deref, response.schema)
          form: async.apply(@deref, response.form)
        }, callback

  deref: (schema, callback) =>
    return callback() unless schema?
    delete schema.url unless schema.url?
    RefParser.dereference(schema, callback)

  getRawSchemas: (callback) =>
    return @oldSchema.getSchemas(callback) if @oldSchema.is()
    return @v1Schema.getSchemas(callback) if @v1Schema.is()
    return @v2Schema.getSchemas(callback) if @v2Schema.is()
    callback null

  resolveSchemaUrls: (schema, callback) =>
    return callback null unless schema?
    resolveSchema = (resolve) =>
      return resolve null, schema unless schema.url?
      @getSchemaFromUrl schema.url, resolve

    resolveSchema (error, newSchema) =>
      return callback null, newSchema unless newSchema.type == 'object'
      async.map newSchema.properties, @resolveSchemaUrls, (error, properties) =>
        newSchema.properties = properties
        return callback null, newSchema
        @resolveSchemaUrls newSchema, callback

  getSchemaFromUrl: (url, callback) =>
    request
      .get(url)
      .accept('application/json')
      .set('Content-Type', 'application/json')
      .end (error, response) =>
        return callback error if error?
        return callback new Error('invlaid response') unless response.ok
        callback(null, response.body)

module.exports = Transmogrifier
