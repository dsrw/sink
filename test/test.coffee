{puts, debug} = require 'sys'
{ok} = require 'assert'
{q} = require '../lib/q'

wait = (time, cb) -> setTimeout cb, time

order = ""
out = (label) ->
  order += label
q ->
  out "1"
  q -> out "2"
  q -> out "3"
  q ->
    out "4"
    q -> out "5"
q -> out "6"
q wait, 5, ->
  out "7"
  q wait, 100, -> out "8"
  q wait, 0, -> out "9"
q ->
  q.parallel (p) ->
    p wait, 100, -> out "d"
    p wait, 0, -> out "b"
    p wait, 50, -> out "c"
    p -> out "a"
  q -> out "e"
q ->
  puts order
  ok order == "123456789abcde"
