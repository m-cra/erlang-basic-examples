%% simple client

-module(client).
-export([start/1]).

-define(PORT, 9927).

start(Str) ->
  {ok, Socket} = gen_tcp:connect("localhost", ?PORT, [binary, {packet, 4}]),
  ok = gen_tcp:send(Socket, term_to_binary(Str)),

  receive
    {tcp, Socket, Bin} ->
      io:format("Client received binary = ~p~n", [Bin]),
      Val = binary_to_term(Bin),
      
      io:format("Client result = ~p~n", [Val]),
      gen_tcp:close(Socket)
  end.
