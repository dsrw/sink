(window? or exports).q = q = (func, args..., cb) ->
  (q.callbacks or= []).push ->
    call func, args, cb, (cb, results) ->
      [callbacks, q.callbacks] = [q.callbacks,[null]]
      cb results...
      q.callbacks = q.callbacks[1..].concat callbacks[1..]
      q.callbacks[0]?()
  q.callbacks[0]() if q.callbacks.length == 1

q.parallel = (body) -> 
  parallel = (done) -> body (func, args..., cb) -> 
    q.i = (q.i or 0) + 1
    call func, args, cb, (cb, results) ->
      cb results...
      done() if --q.i == 0
  q parallel, ->

call = (func, args, cb, body) ->
  if cb then func args..., (results...) -> body cb, results
  else body func
