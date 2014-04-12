GotoHandler = require '../lib/handlers/goto'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "GotoHandler", ->
  subject = null
  beforeEach ->
    subject = new GotoHandler

  describe '@selectedLine', ->
    it 'returns the text for the current line', ->
      debugger
      result = subject.selectedLine(
        getCursor: ->
          getCurrentBufferLine: ->
            'TEST'
      )
      expect(result).toBe 'TEST'

  describe '@getGrammarType', ->
    it 'returns the grammar for the editor', ->
      result = subject.getGrammarType(
        getGrammar: ->
          name: 'TESTING'
      )
      expect(result).toBe('TESTING')

  describe '@convertToJs', ->
    it 'leaves js untouched', ->
      result = subject.convertToJs('TEST', 'JavaScript')

      expect(result).toBe 'TEST'
    it 'converts coffee script to js', ->
      coffeeCode = "require 'some-module'"
      result = subject.convertToJs(coffeeCode, 'CoffeeScript')

      expect(result).toContain("require('some-module')")

  describe '@requiresForSource', ->
    it 'returns any requires contained in the source', ->
      source = 'require("test")'
      results = subject.requiresForSource(source)

      expect(results).toEqual ['test']

  describe '@basePathForEditor', ->
    it 'returns the base directory for the file associated with the editor', ->
      basePath = subject.basePathForEditor(
        getUri: -> '/a/b/c.js'
      )

      expect(basePath).toBe '/a/b'
  describe '@resolveModuleNameToPath', ->
    it 'returns the path for json files', ->
      moduleName = './fixtures/json/test.json'
      baseDir = __dirname
      path = subject.resolveModuleNameToPath moduleName, baseDir

      expect(path).toContain '/spec/fixtures/json/test.json'

    it 'returns the path for js files when extension is included', ->
      moduleName = './fixtures/js/test.js'
      baseDir = __dirname
      path = subject.resolveModuleNameToPath moduleName, baseDir

      expect(path).toContain '/spec/fixtures/js/test.js'

    it 'returns the path for js files when extension is excluded', ->
      moduleName = './fixtures/js/test'
      baseDir = __dirname
      path = subject.resolveModuleNameToPath moduleName, baseDir

      expect(path).toContain '/spec/fixtures/js/test.js'

    it 'returns the path for coffee files when extension is included', ->
      moduleName = './fixtures/coffee/test.coffee'
      baseDir = __dirname
      path = subject.resolveModuleNameToPath moduleName, baseDir

      expect(path).toContain '/spec/fixtures/coffee/test.coffee'

    it 'returns the path for coffee files when extension is included', ->
      moduleName = './fixtures/coffee/test'
      baseDir = __dirname
      path = subject.resolveModuleNameToPath moduleName, baseDir

      expect(path).toContain '/spec/fixtures/coffee/test.coffee'

    it 'returns null if the module cannot be resolved', ->
      moduleName = './Fake'
      baseDir = __dirname

      path = subject.resolveModuleNameToPath moduleName, baseDir

      expect(path).toBe null
