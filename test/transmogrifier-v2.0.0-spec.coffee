Transmogrifier = require '..'
shmock         = require '@octoblu/shmock'
v2Device       = require './v2-schema.json'

describe 'Transmogrifier Convert v2.0.0', ->
  beforeEach ->
    @jsonServer = shmock 0xd00d

  afterEach (done) ->
    @jsonServer.close done

  describe '->convert', ->
    describe 'when converting configure schema', ->
      describe 'when it has a schema', ->
        beforeEach (done) ->
          @sut = new Transmogrifier { device: v2Device, schemaType: 'configure' }
          @sut.convert (error, @response) =>
            done(error)

        it 'should have a schema', ->
          expect(@response.schema).to.deep.equal {
            type: 'object'
            properties:
              options:
                type: 'object'
                properties:
                  example:
                    type: 'string'
          }

        it 'should not have a form schema', ->
          expect(@response.form).to.be.empty

    describe 'when converting message schema', ->
      describe 'when it has a schema', ->
        beforeEach (done) ->
          @sut = new Transmogrifier { device: v2Device, schemaType: 'message' }
          @sut.convert (error, @response) =>
            done(error)

        it 'should have a schema', ->
          expect(@response.schema).to.deep.equal {
            '$schema': 'http://json-schema.org/draft-04/schema#'
            'definitions':
              'example-message-01':
                'type': 'object'
                'properties':
                  'example-opt': 'type': 'string'
                  'another-example-opt': 'type': 'string'
                'required': [
                  'example-opt'
                  'another-example-opt'
                ]
              'example-message-02':
                'type': 'object'
                'properties':
                  'some-opt': 'type': 'string'
                  'another-some-opt': 'type': 'string'
                'required': [
                  'some-opt'
                  'another-some-opt'
                ]
            'type': 'object'
            'properties':
              'example-message-01':
                'type': 'object'
                'properties':
                  'example-opt': 'type': 'string'
                  'another-example-opt': 'type': 'string'
                'required': [
                  'example-opt'
                  'another-example-opt'
                ]
              'example-message-02':
                'type': 'object'
                'properties':
                  'some-opt': 'type': 'string'
                  'another-some-opt': 'type': 'string'
                'required': [
                  'some-opt'
                  'another-some-opt'
                ]
          }

        it 'should not have a form schema', ->
          expect(@response.form).to.be.empty
