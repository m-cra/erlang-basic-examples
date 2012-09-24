%%2-1

%A
1 + 1. %2
[1|[2|[3|[]]]]. %[1,2,3]

%B
A = 1.
B = 2.
A + B. %2
A = A + 1. %no match of right hand side value 2

%C
L = [A|[2,3]]. %[1,2,3]
[[3,2]|1]. %[[3,2]|1]
[H|T] = L. %[1,2,3]
H. %1
T. %[2,3]

%D
%f().
B = 2. %2 
B = 2. %2
2 = B. %2
%%C没有绑定,没法进行模式匹配.
B = C. %variable 'C' is unbound
C = B. %2
B = C. %2
B = C. %2
