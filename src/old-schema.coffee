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
    callback null, {
      schema: @convertToCurrent({ prop: "#{@schemaType}Schema" })
      form: @convertToCurrent({ prop: "#{@schemaType}FormSchema" })
    }

  getSchema: (prop, callback) =>
    return callback(null, _.get(@device, prop))

  convertToCurrent: ({ prop }) =>
    return unless @device[prop]? || @device["#{prop}Url"]?
    schema = @device[prop] ? {}
    url = @device["#{prop}Url"]
    schema.url = url if url?
    wrap =
      type: 'object'
      properties: {}
    wrap.properties[@schemaType] = schema
    return wrap

module.exports = OldSchema
