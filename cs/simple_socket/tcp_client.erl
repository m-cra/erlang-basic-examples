%% tcp client

-module(tcp_client).
-export([start/2]).

%% 启动函数
start(Host, Data) -> 
  %% 连接服务器
  {ok, Socket} = gen_tcp:connect(Host, 9927, [binary, {packet, 0}]),
  %% 发送数据
  send(Socket, Data),
  %% 发送完毕关闭套接字
  ok = gen_tcp:close(Socket).

%% 把收到的数据按照100字节块为单位发送
send(Socket, <<Chunk:100/binary, Rest/binary>>) ->
  gen_tcp:send(Socket, Chunk),
  %% 递归发送
  send(Socket, Rest);

%% 不足100个字节的时候会匹配到这个函数
send(Socket, Rest) -> 
  gen_tcp:send(Socket, Rest).
