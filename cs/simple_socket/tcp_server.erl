%% tcp server

-module(tcp_server).
-export([start/0, wait_connect/2]).

%% 启动函数
start() -> 
  %% 被动模式监听
  %% 重用地址
  {ok, Listen} = gen_tcp:listen(9927, [binary, 
                                {reuseaddr, true},
                                {active, false}]),
  wait_connect(Listen, 0).

%% 等待客户端
wait_connect(Listen, Count) ->
  %% 创建套接字
  {ok, Socket} = gen_tcp:accept(Listen),
  %% wait_connect函数需要导出
  %% 新开启进程来等待下一个套接字客户端
  spawn(?MODULE, wait_connect, [Listen, Count + 1]),
  get_request(Socket, [], Count).

%% 处理请求的函数
get_request(Socket, BinaryList, Count) ->
  case gen_tcp:recv(Socket, 0, 5000) of
    {ok, Binary} -> 
      get_request(Socket, [Binary|BinaryList], Count);
    {error, closed} -> 
      %% 接受完毕后反转顺序
      %% 交由业务函数
      handle(lists:reverse(BinaryList), Count)
  end.

handle(Binary, Count) ->
  %% 打开文件,以序号标记文件名
  {ok, Fd} = file:open("log_file_" ++ integer_to_list(Count), write),
  file:write(Fd, Binary),
  %% 关闭文件
  file:close(Fd).
