%% gs_server

-module(gs_server).
-export([start/0]).

start()->
  %%监听端口
  {ok, ListenSocket} = gen_tcp:listen(1234,[binary,{packet,4},  
                                          {reuseaddr,true},  
                                          {active,true}]),
  %%获取客户端链接  
  {ok, Socket} = gen_tcp:accept(ListenSocket),
  %%关闭监听  
  gen_tcp:close(ListenSocket),
  %%启动一个gen_server  
  {ok, Pid} = socketManager:start_link(),
  %%将客户端链接socket 绑定到gen_server 
  gen_tcp:controlling_process(Socket, Pid).
