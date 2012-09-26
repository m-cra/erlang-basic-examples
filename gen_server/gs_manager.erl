%% gs_impl.erl 

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


start_link()->
  gen_server:start_link({local, manager}, ?MODULE, [], []).

init([])->
  {ok, #state{}}.

handle_call(_Request, _From, State)->
  {reply, ok, State}.

handle_cast(_Msg, State)->
  {noreply, State}.

handle_info(Info, State)->
  io:format("msg received: ~n", []),
  io:format("input msg is: ~w~n", [Info]),
  {noreply, State}.

terminate(_Reason, _State)->
  ok.

code_change(_Old, State,_Ext)->
  {ok, State}.
