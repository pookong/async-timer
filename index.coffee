module.exports = ->

  starts = {}
  measured = {}


  ###
    start time [key]
    @param {string} key
  ###
  start: (key) ->
    starts[key] = process.hrtime()
    measured[key] = null
    return

  ###
    end time [key]
    @param {string} key
  ###
  end: (key) ->
    return unless (start = starts[key])?
    delta = process.hrtime start
    measured[key] = Math.round((delta[0] * 1e9 + delta[1]) / 1e6)
    return

  ###
    wrap async call timing it as [key]
    @param {function(args..., callback)} task
    @param {string} key
    @return {function(args..., callback)}
  ###
  wrap: (task, key) ->
    (args..., next) =>
      @start key
      task args..., =>
        @end key
        next arguments...

  ###
    get object of measured times
    @return {Object.<string, number>}
  ###
  getMeasured: ->
    measured
