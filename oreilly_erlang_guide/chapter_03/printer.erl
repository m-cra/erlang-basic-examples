%%3-2 printer

-module(printer).
-export([number/1, even/1]).

%%
number(0) -> false;

number(N) when N > 0 ->
  number(N - 1),
  io:format("~p~n", [N]).

%%
even(0) -> false;

even(N) when (N >= 2) and (N rem 2 == 0) ->
  even(N - 2),
  io:format("~p~n", [N]);

even(N) when (N > 2) and (N rem 2 == 1) ->
  even(N - 1).
