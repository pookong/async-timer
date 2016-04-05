measureTime = require './'
{assert} = require 'chai'

KEYS =
  RED: 'red'
  GREEN: 'green'
  BLUE: 'blue'
  MAGENTA: 'magenta'

TIMEOUT = 200

TOLERANCE = 10

check = (measured) ->
  assert.isObject measured

  assert.property measured, KEYS.RED
  assert.approximately measured[KEYS.RED], 0, TOLERANCE

  assert.property measured, KEYS.GREEN
  assert.approximately measured[KEYS.GREEN], TIMEOUT, TOLERANCE

  assert.property measured, KEYS.BLUE
  assert.isNull measured[KEYS.BLUE]

  assert.notProperty measured, KEYS.MAGENTA


describe 'start, end', ->

  it 'measures from start to end', (done) ->
    t = measureTime()
    t.start KEYS.RED
    t.end KEYS.RED
    t.start KEYS.GREEN
    t.start KEYS.BLUE
    setTimeout ->
      t.end KEYS.GREEN
      t.end KEYS.MAGENTA
      check t.getMeasured()
      done()
    , TIMEOUT


describe 'wrap', ->

  it 'wraps async functions', (done) ->
    t = measureTime()

    task1 = t.wrap (next) ->
      next()
    , KEYS.RED

    task2 = t.wrap (x, y, next) ->
      setTimeout next, TIMEOUT
    , KEYS.GREEN

    task3 = t.wrap (next) ->
      return
    , KEYS.BLUE

    task1 ->
      task2 'x', 'y', ->
        task3 ->
          throw Error 'this should not be called'
        setTimeout ->
          check t.getMeasured()
          done()
        , TIMEOUT
