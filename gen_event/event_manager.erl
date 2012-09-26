%% event manager

%% 事件管理器本质上是在维护一个 {Module, State} 对的列表
%% 其中每个 Module 是一个事件处理器
%% State 是事件处理器的内部状态

-module(event_manager).

%% 启动event manager进程并且连接
%% gen_event:start则是启动一个独立的event manager
%% 没有supervisor 
%% error_man是注册名
gen_event:start_link({local, error_man}).

%% 添加event handler处理
%% 将调用terminal_logger的init方法
%% 参数是add_handler的第三个参数
%% 返回{ok, State}, State是event handler的内部状态
gen_event:add_handler(error_man, terminal_logger, []).

%% 通知
%% error_man是注册名, no_reply是事件
%% 事件event被当成消息发送给event manager
%% 事件event被接受后event manager为每个event handler调用
%% handle_event(Event, State)
%% 调用顺序和添加顺序相反
%% handle_event返回{ok, NewState}表示event handler的新状态
gen_event:notify(error_man, no_reply).

%% 删除event handler 
%% 将会调用terminal logger的terminate方法
%% 调用参数是delete_handler的第三个参数
%% 返回值会忽略
gen_event:delete_handler(error_man, terminal_logger, []).

%% 停止event manager
%% 每个event handler的terminate都会被调用
gen_event:stop(error_man).
