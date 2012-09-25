%% chat send client

-module(chat_send_client).
-export([start/2]).

%% 启动函数
start(IP, Port) ->
  {ok, Socket} = gen_tcp:connect(IP, Port, [binary, {packet, 4}]),
  talk(Socket).

talk(Socket) ->
  Msg = io:get_line('Input you msg:'),
  ok = gen_tcp:send(Socket, term_to_binary(Msg)),
  talk(Socket).
