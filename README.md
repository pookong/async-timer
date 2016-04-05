tool for measuring time of execution of async code

# START / END
```
asyncTimer = require '@sbks/async-timer'

timer = asyncTimer()

timer.start 'KEY1'
setTimeout ->
  timer.end 'KEY1'
  console.log timer.getMeasured()
, 500
```

# WRAP
```
asyncTimer = require '@sbks/async-timer'

timer = asyncTimer()

task = (next) ->
  setTimeout next, 500

wrapped = timer.wrap task, 'KEY2'

wrapped ->
  console.log timer.getMeasured()
```
