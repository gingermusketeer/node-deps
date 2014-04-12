GotoHandler = require './handlers/goto'

module.exports =
  activate: (state) ->
    atom.workspaceView.command 'node-deps:goto', (new GotoHandler).handler
