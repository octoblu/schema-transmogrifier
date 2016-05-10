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
      describe 'when it has a schema but no form schema', ->
        beforeEach (done) ->
          @sut = new Transmogrifier { device: v1Device, schemaType: 'configure' }
          @sut.convert (error, @response) =>
            done(error)

        it 'should have a schema', ->
          expect(@response.schema).to.deep.equal {
            type: 'object'
            properties:
              options:
                type: 'object'
                properties:
                  something:
                    type: 'string'
          }

        it 'should not have a form schema', ->
          expect(@response.form).to.be.empty
