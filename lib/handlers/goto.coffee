detective = require 'detective'
path = require 'path'
resolve = require 'resolve'
coffeescript = require 'coffee-script'

module.exports = class GotoHandler
  handler: =>
    editor = atom.workspace.getActiveEditor()
    return unless editor?

    line = @selectedLine editor
    grammar = @getGrammarType editor

    jsSourceLine = @convertToJs line, grammar
    requires = @requiresForSource jsSourceLine

    return unless requires.length == 1

    moduleName = requires[0]

    modulePath = @resolveModuleNameToPath moduleName, @basePathForEditor(editor)

    console.log 'modulePath', modulePath

    if modulePath != null
      atom.workspace.open modulePath

  selectedLine: (editor) ->
    editor.getCursor().getCurrentBufferLine()

  getGrammarType: (editor) ->
    editor.getGrammar().name

  convertToJs: (source, grammar) ->
    switch grammar
      when 'CoffeeScript'
        coffeescript.compile source
      else
        source

  requiresForSource: (source) ->
    detective source

  basePathForEditor: (editor) ->
    path.dirname editor.getUri()

  resolveModuleNameToPath: (moduleName, baseDir) ->
    # Detective will throw an exception if the module
    # does not exist on the file system
    try
      resolve.sync moduleName, { basedir: baseDir, extensions: ['.js', '.coffee'] }
    catch e
      console.log e
      null
