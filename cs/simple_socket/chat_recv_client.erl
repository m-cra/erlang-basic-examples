%% chat recv client

-module(chat_recv_client).
-export([start/2]).

%% 启动函数
start(IP, Port) ->
  {ok, Socket} = gen_tcp:connect(IP, Port, [binary, {packet, 4}]),
  recv_msg(Socket).

recv_msg(Socket) ->
  receive
    %% 数据到达
    {tcp, Socket, Bin} ->
      Msg = binary_to_term(Bin),
      io:format("Received msg: ~p~n", [Msg]),
      recv_msg(Socket)
  end.
