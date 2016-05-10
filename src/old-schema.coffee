request = require 'superagent'
async   = require 'async'
request = require 'superagent'
_       = require 'lodash'

class OldSchema
  constructor: ({ @device, @schemaType }) ->
    if @schemaType == 'configure'
      @schemaType = 'options'

  is: =>
    return true if @device["#{@schemaType}SchemaUrl"]?
    return true if @device["#{@schemaType}Schema"]?
    return true if @device["#{@schemaType}FormSchemaUrl"]?
    return true if @device["#{@schemaType}FormSchema"]?
    return false

  getSchemas: (callback) =>
    async.parallel {
      schema: async.apply(@getSchema, "#{@schemaType}Schema")
      form: async.apply(@getSchema, "#{@schemaType}FormSchema")
    }, (error, response) =>
      return callback error if error?
      response.schema = @convertToCurrent({ schema: response.schema }) if response.schema?
      response.form = @convertToCurrent({ schema: response.form }) if response.form?
      callback null, response

  getSchema: (prop, callback) =>
    url = _.get(@device, "#{prop}Url")
    return @getSchemaFromUrl(url, callback) if url?
    return callback(null, _.get(@device, prop))

  convertToCurrent: ({ schema }) =>
    wrap =
      type: 'object'
      properties: {}
    wrap.properties[@schemaType] = schema
    return wrap

  getSchemaFromUrl: (url, callback) =>
    request
      .get(url)
      .accept('application/json')
      .set('Content-Type', 'application/json')
      .end (error, response) =>
        return callback error if error?
        return callback new Error('invlaid response') unless response.ok
        callback(null, response.body)

module.exports = OldSchema
