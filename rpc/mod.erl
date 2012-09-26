%% mod 

-module(mod).
-export([init/0, add/2, where/1, handle/2]).
-import(mod_server, [rpc/2]).

%% 启动函数
init() -> dict:new().

%% 添加
add(Name, Place) ->
  rpc(mod, {add, Name, Place}).

%% 查询
where(Name) -> rpc(mod, {where, Name}).

%% 业务处理回调函数
handle({add, Name, Place}, Dict) -> 
  {ok, dict:store(Name, Place, Dict)};

handle({where, Name}, Dict) -> 
  {dict:find(Name, Dict), Dict}.
