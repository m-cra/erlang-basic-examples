%% gs manager 

-module(gs_manager).
%% 接口定义
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
  %% 第一个参数: 是否为进程注册名字
  %% 第二个参数: 回调模块名称
  %% 第三个参数: 传递给回调模块init的参数
  %% 第四个参数: gen_server相关选项
  gen_server:start_link({local, manager}, ?MODULE, [], []).

%% 启动
init([]) ->
  {ok, #state{}}.
  %% 失败返回{stop, Reasion}
  %% 第三个参数可以实现超时
  %% {ok, #state{}, ?SLEEP_TIME}

%% gen_server:call(Name, Term) -> Term
%% 同步调用,请求-等待结果
handle_call(_Request, _From, State) ->
  {reply, ok, State}.

%% gen_server:cast(Name, Term) -> void
%% 异步调用,调用后立即返回
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
