%%3-5 list_func

-module(list_func).
-export([filter/2, reverse/1, flatten/1]).

%%过滤
filter([], _Max) -> [];

filter([Head|Tail], Max) when Head =< Max ->
  [Head|filter(Tail, Max)];

filter([Head|Tail], Max) when Head > Max ->
  filter(Tail, Max).

%%reverse
reverse([]) -> [];

reverse([Head|Tail]) ->
  reverse(Tail) ++ [Head].

%%flatten
flatten([]) -> [];

flatten([Head|Tail]) -> 
  case Head of 
    [_T|[]] -> [Head|flatten(Tail)]; 
    _Other -> flatten(Head) ++ flatten(Tail)
  end;

flatten(Item) -> [Item].
