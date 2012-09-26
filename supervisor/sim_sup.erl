%% simple sup

-module(simple_sup).
-behaviour(supervisor).

-export([start_link/0]).
-export([init/1]).

start_link() ->
  supervisor:start_link(simple_sup, []).

init(_Args) ->
  {ok, 
    %% 重启策略
    %% one_for_one 如果子进程终止了仅改进程被重启
    %% one_for_all 如果子进程被终止了其他的所有子进程都终止后全部重启
    %% rest_for_one 在被终止的子进程后面的子进程都被终止然后被重启
    %% MaxR, MaxT = 1,60定义重启频率,比如0,1
    %% 如果在最近的 MaxT 秒内发生的重启次数超过了 MaxR 次
    %% 那么督程会终止所有的子进程,然后结束自己
    {{one_for_one, 1, 60}, 
    %% 子进程规格
    [{call, {call, start_link, []}, temporary, brutal_kill, worker, [call]}]
    }}.

%% {Id, StartFunc, Restart, Shutdown, Type, Modules}

%% Id = term() 是督程内部用于标识子进程规范的名称

%% StartFunc = {M, F, A} 定义了用于启动子进程的很难书调用
%% M = F = atom()
%% A = [term()]

%% Restart = permanent | transient | temporary 定义了一个被终止的子进程要在何时被重启
%% permanent 子进程总会被重启
%% transient 子进程只有当其被异常终止时才会被重启，即，退出理由不是 normal
%% temporary 子进程从不会被重启

%% Shutdown = brutal_kill | integer() >=0 | infinity 定义了一个子进程应如何被终止
%% brutal_kill 表示子进程应使用 exit(Child, kill) 进行无条件终止
%% 一个整数超时值表示督程先通过调用 exit(Child, shutdown) 告诉子进程要终止了，然后等待其返回退出信号。如果在指定的事件内没有接受到任何退出信号，那么使用 exit(Child, kill) 无条件终止子进程
%% 如果子进程是另外一个督程，那么应该设置为 infinity 以给予子树足够的时间关闭

%% Type = worker | supervisor 定子进程是督程还是佣程 

%% Modules = [Module] | dynamic 应该为只有一个元素的列表 [Module] 
%% 其中 Module 是回调模块的名称，如果子进程是督程、gen_server或者gen_fsm。
%% 如果子进程是一个gen_event，那么 Modules 应为 dynamic
%% 在升级和降级过程中发布处理器将用到这个信息
%% Module = atom() 
