%%2-2 bool

-module(bool).
-export([b_not/1, b_and/2 ,b_or/2, b_nand/2]).

%b_not
b_not(true) -> 
  false;

b_not(false) ->
  true.

%b_and
b_and(false, _T) ->
  false;

b_and(_T, false) ->
  false;

b_and(_T, _L) ->
  true.

%b_or
b_or(true, _T) ->
  true;

b_or(_T, true) ->
  true;

b_or(_T, _L) ->
  false.

%b_nand
b_nand(T, L) ->
  b_not(b_and(T, L)).
