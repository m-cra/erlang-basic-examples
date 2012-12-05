%% @author debugger
%% @doc 解释怎么编写gen_server回调模块.

%% 编写gen_server回调模块的三个要点
%% 1. 确定回调模块的名称
%% 2. 编写接口函数
%% 3. 回调模块中完成6个函数

-module(my_bank).
-behaviour(gen_server).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

%% 接口函数
start() ->
  gen_server:start_link({local, my_bank}, ?MODULE, [], []).

stop() ->
  gen_server:call(?MODULE, stop).

new_account(Who) ->
  gen_server:call(?MODULE, {new, Who}).

deposit(Who, Amount) ->
  gen_server:call(?MODULE, {add, Who, Amount}).

withdraw(Who, Amount) ->
  gen_server -> call(?MODULE, {remove, Who, Amount}).

%% 回调函数
start_link() ->
  gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%%init([]) ->
%%  {ok, State}.
init([]) ->
  {ok, ets:new(?MODULE, [])}.

%% handle_call(_Request, _From, State) ->
%%  {reply, Reply, State}.

%% 创建
handle_call({new, Who}, _From, Tab) ->
  Reply = ets:lookup(Tab, Who) of
    [] -> ets:insert(Tab, {Who, 0}),
            {welcome, Who};
    [_] -> {Who, you_already_are_a_customer}
  end,
  {reply, Reply, Tab};

%% 加钱
handle_call({add, Who, X}, _From, Tab) ->
  Reply = case ets:lookup(Tab, Who) of
    [] -> not_a_customer;
    [{Who, Balance}] ->
      NewBalance = Balance + X,
      ets:insert(Tab, {Who, NewBalance}),
      {thanks, Who, your_balance_is, NewBalance}
  end,
  {reply, Reply, Tab};

%% 扣钱
handle_call({remove, Who, X}, _From, Tab) ->
  Reply = case ets:lookup(Tab, Who) of
    [] -> not_a_customer;
    [{Who, Balance}] when X =< Balance  ->
      NewBalance = Balance - X,
      ets:insert(Tab, {Who, NewBalance}),
      {thanks, Who, your_balance_is, NewBalance};
    [{Who, Balance}] ->
      {sorry, Who, you_only_have_balance, Balance}
  end,
  {reply, Reply, Tab};
%% 停止
handle_call(stop, _From, Tab) ->
  {stop, normal, stopped, Tab}.

handle_cast(_Msg, State) ->
  {noreply, State}.

handle_info(_Info, State) ->
  {noreply, State}.

terminate(_Reasion, _State) ->
  ok.

code_change(_OldVsn, State, Extra) ->
  {ok, State}.
    