%% tcp client

-module(tcp_client).
-export([start/2]).

start(Host, Data) -> 
  {ok, Socket} = gen_tcp:connect(Host, 9927, [binary, {packet, 0}]),
  send(Socket, Data),
  ok = gen_tcp:close(Socket).

send(Socket, <<Chunk:100/binary, Rest/binary>>) ->
  gen_tcp:send(Socket, Chunk),
  send(Socket, Rest);

send(Socket, Rest) -> 
  gen_tcp:send(Socket, Rest).
