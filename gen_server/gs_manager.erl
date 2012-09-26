%% gs manager 

-module(gs_manager).
-behaviour(gen_server).

-export([init/1,
         handle_call/3,
         handle_cast/2,
         handle_info/2,
         terminate/2,
         code_change/3,
         start_link/0]).

-record(state, {}).

%% 服务器启动函数
start_link() ->
  gen_server:start_link({local, manager}, ?MODULE, [], []).

%% 启动
init([]) ->
  {ok, #state{}}.

%% 同步调用
handle_call(_Request, _From, State) ->
  {reply, ok, State}.

%% 异步调用
handle_cast(_Msg, State) ->
  {noreply, State}.

%% 处理原生消息
handle_info(Info, State) ->
  io:format("msg received: ~n", []),
  io:format("input msg: ~w~n", [Info]),
  {noreply, State}.

%% 终结
terminate(_Reason, _State) ->
  ok.

%% 动态部署
code_change(_Old, State, _Ext) ->
  {ok, State}.
