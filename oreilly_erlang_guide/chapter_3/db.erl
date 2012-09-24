%%3-4 db

-module(db).
-export([new/0, destroy/1, write/3, delete/2, read/2, match/2]).

%%创建
new() -> [].

%%销毁
destroy(_Db) -> [].

%%写入
write(Key, Element, Db) -> 
  [{Key, Element}|Db].

%%删除
delete(_Key, []) -> [];

delete(Key, [Head|Tail]) -> 
  case Head of
    {Key, _T} -> delete(Key, Tail);
    _Other -> [Head|delete(Key, Tail)]
  end.

%%读取
read(_Key, []) -> 
  {error, instance};

read(Key, [Head|Tail]) -> 
  case Head of 
    {Key, Element} -> {ok, Element};
    _Other -> read(Key, Tail)
  end.

%%匹配
match(_Element, []) -> [];

match(Element, [Head|Tail]) -> 
  case Head of 
    {Key, Element} -> [Key|match(Element, Tail)];
    _Other -> match(Element, Tail)
  end.
