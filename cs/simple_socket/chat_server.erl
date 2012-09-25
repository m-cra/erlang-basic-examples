%% chat server

-module(chat_server).
-export([start/1]).

%% 套接字选项
%% 这个宏定义不错
-define(TCP_OPTIONS, [list, {packet, 0}, {active, false}, {reuseaddr, true}]).

%% 启动函数,启动指定端口
start(Port) ->
  %% 直接创建管理客户端的进程
  %% 太猛了
  Pid = spawn(fun() -> manage_clients([]) end),
  %% 注册别名
  register(client_manager, Pid),
  %% 开始监听
  {ok, LSocket} = gen_tcp:listen(Port, ?TCP_OPTIONS),
  %% 等待客户端上门
  do_accept(LSocket).

%% 创建套接字函数
do_accept(LSocket) ->
  %% 创建关联客户端套接字
  {ok, Socket} = gen_tcp:accept(LSocket),
  %% 为并发活动创建进程
  spawn(fun() -> handle_client(Socket) end),
  %% 加到被管理列表
  client_manager ! {connect, Socket},
  %% 继续
  do_accept(LSocket).

%% 处理套接字活动
handle_client(Socket) ->
  case gen_tcp:recv(Socket, 0) of
    %% 数据到达
    {ok, Data} ->
      %% 内容处理
      client_manager ! {data, Data},
      %% 继续处理套接字消息
      handle_client(Socket);
    %% 套接字错误
    {error, closed} ->
      client_manager ! {disconnect, Socket}
  end.

%% 客户端套接字管理
manage_clients(Sockets) ->
  receive
    %% 新的客户端套接字建立好
    {connect, Socket} ->
      io:fwrite("Socket connected: ~w~n", [Socket]),
      %% 附加到列表中
      NewSockets = [Socket | Sockets];
    %% 断开连接
    {disconnect, Socket} ->
      io:fwrite("Socket disconnected: ~w~n", [Socket]),
      %% 从列表中删除
      NewSockets = lists:delete(Socket, Sockets);
    %% 数据
    {data, Data} ->
      %% 往所有的客户端套接字发送
      %% 聊天室广播
      send_data(Sockets, Data),
      %% 非常重要!!!???
      NewSockets = Sockets
  end,
  manage_clients(NewSockets).

send_data(Sockets, Data) ->
  %% 函数类型
  SendData = fun(Socket) ->
      gen_tcp:send(Socket, Data)
  end,
  %% 高阶函数
  lists:foreach(SendData, Sockets).
