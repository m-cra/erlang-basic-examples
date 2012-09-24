%%2-2 demo
-module(demo).
-export([double/1]).

double(Value) ->
  times(Value, 2).

times(X, Y) ->
  X * Y.
