%% mod server
%% 本服务器本身不处理业务
%% 业务处理通过加载外部Module来实现

-module(mod_server).
-export([start/2, rpc/2]).

%% 启动函数
start(Name, Mod) ->
  %% 调用加载模块的init初始化
  %% 初始化函数会返回初始状态值
  register(Name, spawn(fun()->loop(Name, Mod, Mod:init()) end)).

%% 向注册进程发送消息
rpc(Name, Request) -> 
  Name ! {self(), Request},
  receive
    {Name, Response} -> Response
  end.

loop(Name, Mod, State) ->
  receive
    {From, Request} -> 
      %% 业务模块处理请求
      {Response, NewState} = Mod:handle(Request, State),
      %% 业务数据返回
      From ! {Name, Response},
      loop(Name, Mod, NewState)
  end.
