%% recent logger

-module(recent_logger).
-behaviour(gen_enevt).

-export([start/0, stop/0, log/1, report/0, release/0])

%% gen_event callbacks
-export([init/1, handle_event/2, handle_call/2, terminate/2]).
-define(NAME, logger_manager).

%% start behaviour
start() ->
  case gen_event:start_link({local, ?NAME}) of
    Ret = {ok, _Pid} ->
      gen_event:add_handler(?NAME, ?MODULE, []),
      Ret;
    Other ->
      Other
  end.

%% stop
stop() ->
  gen_envent:stop(?NAME).

%% notify an envent about log
log(E) ->
  gen_enevt:notify(?NAME, {log, E}).

%% report the all log
report() ->
  gen_event:call(?NAME, ?MODULE, report).

%% release this handler
release() ->
  gen_event:delete_handler(?NAME, ?MODULE, release).

init(_Arg) ->
  io:format("start recent log handler~n"),
  {ok, []}.

handle_event({log, E}, List) ->
  {ok, trim([E | List])}.

handle_call(report, List) ->
  List.

terminate(stop, _List) ->
  io:format("recent log handler stop~n"),
  ok;
terminate(release, _List) ->
  io:format("recent log handler release~n"),
  ok.

%% save the recent five log
trim([E1, E2, E3, E4, E5 | []) ->
    [E1, E2, E3, E4, E5];
  trim(List) ->
    List.
