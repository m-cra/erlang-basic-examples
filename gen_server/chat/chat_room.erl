%% chat room
%% 1.genPid for every client connection
%% 2.broadcast message to all clientSessions

-module(chat_room).
-behaviour(gen_server).

%%
%% Include files
%%
-include("clientinfo.hrl").
-include("message.hrl").
-record(state,{}).

%%
%% Exported Functions
%%
-export([start_link/0,init/1,getPid/0,bindPid/2,broadCastMsg/1,logout/1]).
-export([handle_call/3,handle_info/2,handle_cast/2,code_change/3,terminate/2]).
%%
%% API Functions
%%
start_link()->
  gen_server:start_link({local,?MODULE}, ?MODULE, [],[]).

%%to init all
%%1.start id_generator
%%2.create session table to store clientinfo
%%
init([])->
  id_generator:start_link(),
  ets:new(clientinfo,[public,
      ordered_set,
      named_table,
      {keypos,#clientinfo.id}
    ]),
  {ok,#state{}}.


handle_call({getpid,Id},From,State)->
  {ok,Pid}=client_session:start_link(Id),
  {reply,Pid,State};

handle_call({remove_clientinfo,Ref},From,State)->
  Key=Ref#clientinfo.id,
  ets:delete(clientinfo, Key);

handle_call({sendmsg,Msg},From,State)->
  Key=ets:first(clientinfo),
  io:format("feching talbe key is ~p~n",[Key]),
  sendMsg(Key,Msg),
  {reply,ok,State}.

%%process messages
handle_info(Request,State)->  
  {noreply,State}.

handle_cast(_From,State)->  
  {noreply,State}.

terminate(_Reason,_State)->
  ok.

code_change(_OldVersion,State,Ext)->
  {ok,State}.

%%
%% Local Functions
%%
%% generate new Pid for eache conecting client
getPid()->
  Id=id_generator:getnewid(client),
  Pid=gen_server:call(?MODULE,{getpid,Id}),
  io:format("id generated ~w~n",[Id]),
  #clientinfo{id=Id,pid=Pid}.

%%bind Pid to Socket
%%create new record and store into table
bindPid(Record,Socket)->  
  io:format("binding socket...~n"),
  case gen_tcp:controlling_process(Socket, Record#clientinfo.pid) of
    {error,Reason}->
      io:format("binding socket...error~n");
    ok ->

      NewRec =#clientinfo{id=Record#clientinfo.id,socket=Socket,pid=Record#clientinfo.pid},
      io:format("chat_room:insert record ~p~n",[NewRec]),
      %store clientinfo to ets
      ets:insert(clientinfo, NewRec),
      %then we send info to clientSession to update it's State (Socket info)
      Pid=Record#clientinfo.pid,
      Pid!{bind,Socket},
      io:format("clientBinded~n")
      %start client reciving
      %Pid!{start,Pid}
  end.

%%generate random name
%%and call setInfo(name)
generatename()->
  ok.


%%broad CastMsg to all connected clientSessions
broadCastMsg(Msg)->
  gen_server:call(?MODULE, {sendmsg,Msg}).

sendMsg(Key,Msg)->
  case ets:lookup(clientinfo, Key)of
    [Record]->
      io:format("Record found ~p~n",[Record]),
      Pid=Record#clientinfo.pid,
      %while send down we change msg type to dwmsg
      io:format("send smg to client_session ~p~n",[Pid]),
      Pid!{dwmsg,Msg},      
      Next=ets:next(clientinfo, Key),
      sendMsg(Next,Msg);
    []->
      io:format("no clientinfo found~n")
  end,
  ok;

sendMsg([],Msg)->
  ok.

%%return all connected clientinfo to sender
getMembers(From)->
  ok.

%%set clientinfo return ok or false
%% when ok broadcast change
%% user can changge name later
setInfo(ClientInfo,From)->
  ok.

logout(Ref)->
  gen_server:call(?MODULE, {remove_clientinfo,Ref}),
  ok.
