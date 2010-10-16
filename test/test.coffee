{puts} = require 'sys'
{ok} = require 'assert'
{q} = require '../lib/sink'

wait = (time, cb) -> setTimeout cb, time
order = []
step = (step) ->
  order.push step

q ->
  step 1
  q -> step 2
  q -> step 3
  q ->
    step 4
    q -> step 5
q -> step 6
q wait, 5, ->
  step 7
  q wait, 100, -> step 8
  q wait, 0, -> step 9
q ->
  q.parallel (p) ->
    p wait, 100, -> step 13
    p wait, 0, -> step 11
    p wait, 50, -> step 12
    p -> step 10
  q -> step 14
q ->
  step 15
  ok order.join() == "1,2,3,4,5,6,7,8,9,10,11,12,13,14,15"
  puts "done: #{order}"
