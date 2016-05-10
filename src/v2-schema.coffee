async   = require 'async'
_       = require 'lodash'

class V2Schema
  constructor: ({ @device, @schemaType }) ->

  is: =>
    return false unless @device.schemas?
    return false unless @device.schemas.version == '2.0.0'
    return true

  getSchemas: (callback) =>
    async.parallel {
      schema: async.apply(@getSchema, "schemas.#{@schemaType}")
      form: async.apply(@getSchema, "schemas.form.#{@schemaType}")
    }, callback

  getSchema: (prop, callback) =>
    schema = _.get @device, prop
    return callback null, schema ? {}

module.exports = V2Schema
