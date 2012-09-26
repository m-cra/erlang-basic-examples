%% die please
%% simple gen server

-module(die_please).
-behaviour(gen_server).

-export([start_link/0]).
-export([init/1, 
         handle_call/3, 
         handle_cast/2, 
         handle_info/2, 
         terminate/2, 
         code_change/3]).

-define(SERVER, ?MODULE).
-define(SLEEP_TIME, (2 * 1000)).

-record(state, {}).

start_link() ->
  gen_server:start_link({local, ?SERVER}, ?SERVER, [], []).

init([]) ->
  %% 设置超时时间
  {ok, #state{}, ?SLEEP_TIME}.

handle_call(_Request, _From, State) ->
  Reply = ok,
  {reply, Reply, State}.

handle_cast(_Msg, State) -> 
  {noreply, State}.

handle_info(timeout, Satate) ->
  %% 引发异常
  i_want_to_die = right_now,
  {noreply, Satate}.

terminate(_Reasion, _State) ->
  ok.

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.
