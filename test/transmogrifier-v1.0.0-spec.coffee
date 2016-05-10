Transmogrifier = require '..'
shmock         = require '@octoblu/shmock'
v1Device       = require './v1-schema.json'

describe 'Transmogrifier Convert v1.0.0', ->
  beforeEach ->
    @jsonServer = shmock 0xd00d

  afterEach (done) ->
    @jsonServer.close done

  describe '->convert', ->
    describe 'when converting configure schema', ->
      describe 'when it has a schema', ->
        beforeEach (done) ->
          @sut = new Transmogrifier { device: v1Device, schemaType: 'configure' }
          @sut.convert (error, @response) =>
            done(error)

        it 'should have a schema', ->
          expect(@response.schema).to.deep.equal {
            type: 'object'
            properties:
              command:
                type: 'object'
                properties:
                  action:
                    type: 'string',
                    enum: ['vibrate', 'requestBlueToothStrength', 'zeroOrientation'],
                    default: 'vibrate'
                  vibrationLength:
                    type : 'string',
                    enum : ['short', 'medium', 'long'],
                    default : 'short'
          }

        it 'should not have a form schema', ->
          expect(@response.form).to.be.empty

    describe 'when converting message schema', ->
      describe 'when it has a schema', ->
        beforeEach (done) ->
          @sut = new Transmogrifier { device: v1Device, schemaType: 'message' }
          @sut.convert (error, @response) =>
            done(error)

        it 'should have a schema', ->
          expect(@response.schema).to.deep.equal {
            $schema: 'http://json-schema.org/draft-04/schema#',
            definitions:
              'yo-age':
                title: 'YoAge',
                type: 'object',
                properties:
                  firstName:
                    type: 'string'
                  lastName:
                    type: 'string'
              'yo-deets':
                title: 'YoDeets',
                type: 'object',
                properties:
                  age:
                    type: 'integer',
                    title: 'Age'
                  bio:
                    type: 'string',
                    title: 'Bio'
            type: 'object',
            properties:
              'yo-age':
                title: 'YoAge',
                type: 'object',
                properties:
                  firstName:
                    type: 'string'
                  lastName:
                    type: 'string'
              'yo-deets':
                title: 'YoDeets',
                type: 'object',
                properties:
                  age:
                    type: 'integer',
                    title: 'Age'
                  bio:
                    type: 'string',
                    title: 'Bio'
            }

        it 'should not have a form schema', ->
          expect(@response.form).to.be.empty
