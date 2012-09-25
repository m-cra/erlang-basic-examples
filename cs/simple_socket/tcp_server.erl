%% tcp server

-module(tcp_server).
-export([start/0, wait_connect/2]).

start() -> 
  %% 被动模式监听
  {ok, Listen} = gen_tcp:listen(9927, [binary, 
                                {reuseaddr, true},
                                {active, false}]),
  wait_connect(Listen, 0).

wait_connect(Listen, Count) ->
  {ok, Socket} = gen_tcp:accept(Listen),
  spawn(?MODULE, wait_connect, [Listen, Count + 1]),
  get_request(Socket, [], Count).

get_request(Socket, BinaryList, Count) ->
  case gen_tcp:recv(Socket, 0, 5000) of
    {ok, Binary} -> 
      get_request(Socket, [Binary|BinaryList], Count);
    {error, closed} -> 
      handle(lists:reverse(BinaryList), Count)
  end.

handle(Binary, Count) ->
  {ok, Fd} = file:open("log_file_" ++ integer_to_list(Count), write),
  file:write(Fd, Binary),
  file:close(Fd).
