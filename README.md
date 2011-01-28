# sink

sink is a pair of simple sequence functions for untangling async code.
    
    {q} = require 'sink'
    for name, dir of dirs 
      q path.exists, dir, (exists) ->
        die "#{dir} doesn't exist" unless exists
    q -> puts "looks good."

## q

The `q` function takes either a single callback, or a function, optional args, and a callback.  `q` calls can be made from anywhere.

    q process.nextTick ->
      puts "In the town"
      q process.nextTick -> puts "where I was born"
    q -> puts "There lived a man"
    q process.nextTick -> puts "Who sailed the sea"
    q -> puts "The end!"

## q.parallel

`q.parallel` runs a series of callbacks concurrently.  The next `q`'d function won't fire until they've all completed. 

    wait = (time, cb) -> setTimeout cb, time 
    q.parallel (p) ->
      p wait, 100, -> puts "A"
      p wait, 50, -> puts "B"
      p wait, 0, -> puts "C"
    q -> puts "Now I know my CBAs"

## The Good

sink is only 20 lines long, and should more or less do what is expected even with complicated nesting.  It allows for a succinct style and leads to more readable code than nested callbacks, and provides greater freedom than other step type libraries.

## The Bad

I don't really know what I'm doing.  This has only been tested on toy projects, and has no error handling baked in.  There's only a single global `q`, so this will fall down badly if you perform non parallel actions during web requests, as each request will have to wait its turn.  Per request `q`s will be added soon.
