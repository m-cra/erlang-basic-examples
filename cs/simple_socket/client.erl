%% simple client

-module(client).
-export([start/1]).

-define(PORT, 9927).

start(Str) ->
  %% 连接服务器
  {ok, Socket} = gen_tcp:connect("localhost", ?PORT, [binary, {packet, 4}]),
  %% 发送消息
  ok = gen_tcp:send(Socket, term_to_binary(Str)),

  receive
    %% 服务器有内容返回
    {tcp, Socket, Bin} ->
      io:format("Client received binary = ~p~n", [Bin]),
      Val = binary_to_term(Bin),
      
      io:format("Client result = ~p~n", [Val]),
      %% 关闭套接字
      gen_tcp:close(Socket)
  end.
