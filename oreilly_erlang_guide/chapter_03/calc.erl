%% 3-1 calc

-module(calc).
-export([sum/1, sum/2]).

%%
sum(0) -> 
  0;

sum(N) when N > 0 -> 
  N + sum(N - 1).

%%
sum(N, M) when N > M ->
  0;

sum(N, M) when (N =< M) -> 
  N + sum(N + 1, M).
