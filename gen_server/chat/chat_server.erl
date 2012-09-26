%% chat server

-module(chat_server).
-export([start/0]).

start()->
  chat_room:start_link(),
  chat_acceptor:start(3377),
  ok.
