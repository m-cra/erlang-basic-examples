-module(simple_win).
-compile(export_all).

-include("wx.hrl").

-define(ABOUT, ?wxID_ABOUT).
-define(EXIT, ?wxID_EXIT).

start() ->
  wx:new(),
  Frame = wxFrame:new(wx:null(), ?wxID_ANY, "Simple Window"),
  setup(Frame),
  wxFrame:show(Frame),
  %loop(Frame),
  wx:destory().

setup(Frame) ->
  MenuBar = wxMenuBar:new(),
  File = wxMenu:new(),
  Help = wxMenu:new(),

  wxMenu:append(Help, ?ABOUT, "About Simple Window"),
  wxMenu:append(File, ?EXIT, "Quit"),

  wxMenuBar:append(MenuBar, File, "&File"),
  wxMenuBar:append(MenuBar, Help, "&Help"),

  wxFrame:setMenuBar(Frame, MenuBar),

  wxFrame:createStatusBar(Frame),
  wxFrame:setStatusText(Frame, "Welcome to wxErlang."),

  wxFrame:connect(Frame, command_menu_selected),
  wxFrame:connect(Frame, close_window).
