request = require 'superagent'
async   = require 'async'
_       = require 'lodash'

class V1Schema
  constructor: ({ @device, @schemaType }) ->
    @schemaType = 'messages' if @schemaType == 'message'

  is: =>
    return false unless @device.schemas?
    return false unless @device.schemas.version == '1.0.0'
    return false unless _.isArray @device.schemas.messages
    return true

  getSchemas: (callback) =>
    async.parallel {
      schema: async.apply(@getSchema, "schemas.#{@schemaType}")
    }, callback

  getSchema: (prop, callback) =>
    schema = _.get @device, prop
    if _.isArray schema
      return callback null, @convertArrayToRefs(schema)
    return callback null, schema

  convertArrayToRefs: (schemaArray) =>
    properties = {}
    definitions = {}

    _.each schemaArray, (schema, i) =>
      title = _.kebabCase schema.title ? "message-#{i}"
      properties[title] = $ref: "#/definitions/#{title}"
      definitions[title] = schema

    refsSchema =
      $schema: 'http://json-schema.org/draft-04/schema#',
      definitions: definitions
      type: 'object',
      properties: properties
    return refsSchema

module.exports = V1Schema
