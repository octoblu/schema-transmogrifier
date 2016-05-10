request = require 'superagent'
async   = require 'async'
_       = require 'lodash'

class Transmogrifier
  convert: ({ device, schemaType }, callback) =>
    if @_isOld { device, schemaType }
      return @_getOldSchemas { device, schemaType }, callback

    if @_isNew { device, schemaType }
      return @_getNewSchemas { device, schemaType  }, callback

    callback null, { }

  _getOldSchemaType: ({ schemaType }) =>
    if schemaType == 'configure'
      return 'options'
    return schemaType

  _getNewSchemaType: ({ schemaType }) =>
    if schemaType == 'options'
      return 'configure'
    return schemaType

  _getOldSchemas: ({ device, schemaType }, callback) =>
    schemaType = @_getOldSchemaType({ schemaType })
    async.parallel {
      schema: async.apply(@_getOldSchema, { device, prop: "#{schemaType}Schema" })
      form: async.apply(@_getOldSchema, { device, prop: "#{schemaType}FormSchema" })
    }, (error, response) =>
      return callback error if error?
      response.schema = @_convertOldToNew({ schema: response.schema, schemaType }) if response.schema?
      response.form = @_convertOldToNew({ schema: response.form, schemaType }) if response.form?
      callback null, response

  _getOldSchema: ({ device, prop }, callback) =>
    url = _.get(device, "#{prop}Url")
    return @_getSchemaFromUrl(url, callback) if url?
    return callback(null, _.get(device, prop))

  _convertOldToNew: ({ schema, schemaType }) =>
    wrap =
      type: 'object'
      properties: {}
    wrap.properties[schemaType] = schema
    return wrap

  _getNewSchemas: ({ device, schemaType }, callback) =>
    schemaType = @_getNewSchemaType({ schemaType })
    callback null, {
      schema: device.schemas["#{schemaType}"],
      form: device.schemas.form["#{schemaType}"]
    }

  _isOld: ({ device, schemaType }) =>
    schemaType = @_getOldSchemaType({ schemaType })
    return true if device["#{schemaType}SchemaUrl"]?
    return true if device["#{schemaType}Schema"]?
    return true if device["#{schemaType}FormSchemaUrl"]?
    return true if device["#{schemaType}FormSchema"]?
    return false

  _isNew: ({ device, schemaType }) =>
    schemaType = @_getNewSchemaType({ schemaType })
    return false unless device.schemas?
    return true if device.schemas["#{schemaType}"]?
    return false

  _getSchemaFromUrl: (url, callback) =>
    request
      .get(url)
      .accept('application/json')
      .set('Content-Type', 'application/json')
      .end (error, response) =>
        return callback error if error?
        return callback new Error('invlaid response') unless response.ok
        callback(null, response.body)

module.exports = Transmogrifier
