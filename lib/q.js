(function() {
  var call, q;
  var __slice = Array.prototype.slice;
  ((typeof window !== "undefined" && window !== null) || exports).q = (q = function(func) {
    var args;
    var _len = arguments.length, _result = _len >= 3, cb = arguments[_result ? _len - 1 : 1];
    args = __slice.call(arguments, 1, _len - 1);
    (q.callbacks || (q.callbacks = [])).push(function() {
      return call(func, args, cb, function(cb, results) {
        var _ref, callbacks;
        _ref = [q.callbacks, [null]];
        callbacks = _ref[0];
        q.callbacks = _ref[1];
        cb.apply(this, results);
        q.callbacks = q.callbacks.slice(1).concat(callbacks.slice(1));
        return (typeof (_ref = q.callbacks[0]) === "function" ? _ref() : undefined);
      });
    });
    if (q.callbacks.length === 1) {
      return q.callbacks[0]();
    }
  });
  q.parallel = function(body) {
    var parallel;
    parallel = function(done) {
      return body(function(func) {
        var args;
        var _len = arguments.length, _result = _len >= 3, cb = arguments[_result ? _len - 1 : 1];
        args = __slice.call(arguments, 1, _len - 1);
        q.i = (q.i || 0) + 1;
        return call(func, args, cb, function(cb, results) {
          cb.apply(this, results);
          if (--q.i === 0) {
            return done();
          }
        });
      });
    };
    return q(parallel, function() {});
  };
  call = function(func, args, cb, body) {
    return cb ? func.apply(this, args.concat([function() {
      var results;
      results = __slice.call(arguments, 0);
      return body(cb, results);
    }])) : body(func);
  };
}).call(this);
