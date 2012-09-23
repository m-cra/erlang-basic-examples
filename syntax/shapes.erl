-module(shapes).
-compile(export_all).

area({square, Side}) -> 
  Side * Side;

area({_Other}) ->
  {error, invalid_object}.
