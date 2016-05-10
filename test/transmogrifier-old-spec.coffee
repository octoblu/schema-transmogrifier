Transmogrifier = require '..'
shmock         = require '@octoblu/shmock'

describe 'Transmogrifier Convert Old', ->
  beforeEach ->
    @jsonServer = shmock 0xd00d

  afterEach (done) ->
    @jsonServer.close done

  describe '->convert', ->
    describe 'when converting options schema', ->
      describe 'when using old schema', ->
        describe 'when it does not have schema', ->
          beforeEach (done) ->
            device = {}

            @sut = new Transmogrifier { device, schemaType: 'configure' }
            @sut.convert (error, @response) =>
              done(error)

          it 'should have an empty response', ->
            expect(@response).to.be.empty

        describe 'when it has a schema but no form schema', ->
          beforeEach (done) ->
            device =
              optionsSchema:
                type: 'object'
                properties:
                  something:
                    type: 'string'

            @sut = new Transmogrifier { device, schemaType: 'configure' }

            @sut = new Transmogrifier { device, schemaType: 'configure' }
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

      describe 'when it has a both schemas', ->
        beforeEach (done) ->
          device =
            optionsSchema:
              type: 'object'
              properties:
                something:
                  type: 'string'
            optionsFormSchema:
              type: 'object'
              properties:
                formSomething:
                  type: 'string'

          @sut = new Transmogrifier { device, schemaType: 'configure' }
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
          expect(@response.form).to.deep.equal {
            type: 'object'
            properties:
              options:
                type: 'object'
                properties:
                  formSomething:
                    type: 'string'
          }

      describe 'when both schemas have url', ->
        beforeEach (done) ->
          @messageSchemaCall = @jsonServer
            .get("/message-schema")
            .reply(200, {
              type: 'object'
              properties:
                something:
                  type: 'string'
            })
          @messageSchemaUrlCall = @jsonServer
            .get("/message-form-schema")
            .reply(200, {
              type: 'object'
              properties:
                formSomething:
                  type: 'string'
            })
          device =
            optionsSchemaUrl: "http://localhost:#{0xd00d}/message-schema"
            optionsFormSchemaUrl: "http://localhost:#{0xd00d}/message-form-schema"

          @sut = new Transmogrifier { device, schemaType: 'configure' }
          @sut.convert (error, @response) =>
            done(error)

        it 'should get message schema', ->
          @messageSchemaCall.done()

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

        it 'should get message url schema', ->
          @messageSchemaUrlCall.done()

        it 'should not have a form schema', ->
          expect(@response.form).to.deep.equal {
            type: 'object'
            properties:
              options:
                type: 'object'
                properties:
                  formSomething:
                    type: 'string'
          }

    describe 'when converting message schema', ->
      describe 'when using old schema', ->
        describe 'when it does not have schema', ->
          beforeEach (done) ->
            device = {}

            @sut = new Transmogrifier { device, schemaType: 'message' }
            @sut.convert (error, @response) =>
              done(error)

          it 'should have an empty response', ->
            expect(@response).to.be.empty

        describe 'when it has a schema but no form schema', ->
          beforeEach (done) ->
            device =
              messageSchema:
                type: 'object'
                properties:
                  something:
                    type: 'string'

            @sut = new Transmogrifier { device, schemaType: 'message' }
            @sut.convert (error, @response) =>
              done(error)

          it 'should have a schema', ->
            expect(@response.schema).to.deep.equal {
              type: 'object'
              properties:
                message:
                  type: 'object'
                  properties:
                    something:
                      type: 'string'
            }

          it 'should not have a form schema', ->
            expect(@response.form).to.be.empty

      describe 'when it has a both schemas', ->
        beforeEach (done) ->
          device =
            messageSchema:
              type: 'object'
              properties:
                something:
                  type: 'string'
            messageFormSchema:
              type: 'object'
              properties:
                formSomething:
                  type: 'string'

          @sut = new Transmogrifier { device, schemaType: 'message' }
          @sut.convert (error, @response) =>
            done(error)

        it 'should have a schema', ->
          expect(@response.schema).to.deep.equal {
            type: 'object'
            properties:
              message:
                type: 'object'
                properties:
                  something:
                    type: 'string'
          }

        it 'should not have a form schema', ->
          expect(@response.form).to.deep.equal {
            type: 'object'
            properties:
              message:
                type: 'object'
                properties:
                  formSomething:
                    type: 'string'
          }

      describe 'when both schemas have url', ->
        beforeEach (done) ->
          @messageSchemaCall = @jsonServer
            .get("/message-schema")
            .reply(200, {
              type: 'object'
              properties:
                something:
                  type: 'string'
            })
          @messageSchemaUrlCall = @jsonServer
            .get("/message-form-schema")
            .reply(200, {
              type: 'object'
              properties:
                formSomething:
                  type: 'string'
            })
          device =
            messageSchemaUrl: "http://localhost:#{0xd00d}/message-schema"
            messageFormSchemaUrl: "http://localhost:#{0xd00d}/message-form-schema"

          @sut = new Transmogrifier { device, schemaType: 'message' }
          @sut.convert (error, @response) =>
            done(error)

        it 'should get message schema', ->
          @messageSchemaCall.done()

        it 'should have a schema', ->
          expect(@response.schema).to.deep.equal {
            type: 'object'
            properties:
              message:
                type: 'object'
                properties:
                  something:
                    type: 'string'
          }

        it 'should get message url schema', ->
          @messageSchemaUrlCall.done()

        it 'should not have a form schema', ->
          expect(@response.form).to.deep.equal {
            type: 'object'
            properties:
              message:
                type: 'object'
                properties:
                  formSomething:
                    type: 'string'
          }
