-module(first).
-export([fact/1, fact/0]).

fact() -> 
    "Hello".

fact(0) -> 1;
fact(N) -> N * fact(N-1).


%Last login: Mon Sep 10 08:14:55 on ttys000
%Melindas-MacBook-Pro:~ melindatoth$ erl
%Erlang/OTP 20 [erts-9.0] [source] [64-bit] [smp:4:4] [ds:4:4:10] [async-threads:10] [hipe] [kernel-poll:false] [dtrace]

%Hello
%Eshell V9.0  (abort with ^G)
%1> 1.
%1
%2> rgfd
%2> gfdgfdg
%2> dfg.ű
%* 3: illegal character
%2> 1 + 2.
%3
%3> 1 
%3> +
%3> 2.
%3
%4> lists:nth(2, [3,4,5]).
%4
%5> lists:max([3,4,5]).   
%5
%6> lists:max([3,4,5]) + 3. 
%8
%7> lists:max([3,4,5]) + b.
%** exception error: an error occurred when evaluating an arithmetic expression
     %in operator  +/2
        %called as 5 + b
%8> 1/0.
%** exception error: an error occurred when evaluating an arithmetic expression
     %in operator  '/'/2
        %called as 1 / 0
%9> 
%BREAK: (a)bort (c)ontinue (p)roc info (i)nfo (l)oaded
       %(v)ersion (k)ill (D)b-tables (d)istribution
%^CMelindas-MacBook-Pro:~ melindatoth$ erl
%Erlang/OTP 20 [erts-9.0] [source] [64-bit] [smp:4:4] [ds:4:4:10] [async-threads:10] [hipe] [kernel-poll:false] [dtrace]

%Hello
%Eshell V9.0  (abort with ^G)
%1> q().
%ok
%2> Melindas-MacBook-Pro:~ melindatoth$ erl
%Erlang/OTP 20 [erts-9.0] [source] [64-bit] [smp:4:4] [ds:4:4:10] [async-threads:10] [hipe] [kernel-poll:false] [dtrace]

%Hello
%Eshell V9.0  (abort with ^G)
%1> processes().
%[<0.0.0>,<0.1.0>,<0.2.0>,<0.3.0>,<0.6.0>,<0.32.0>,<0.33.0>,
 %<0.35.0>,<0.36.0>,<0.37.0>,<0.38.0>,<0.40.0>,<0.41.0>,
 %<0.42.0>,<0.43.0>,<0.44.0>,<0.45.0>,<0.46.0>,<0.47.0>,
 %<0.48.0>,<0.49.0>,<0.50.0>,<0.51.0>,<0.52.0>,<0.53.0>,
 %<0.54.0>,<0.55.0>,<0.58.0>,<0.59.0>]
%2> self().
%<0.59.0>
%3> 1/0.
%** exception error: an error occurred when evaluating an arithmetic expression
     %in operator  '/'/2
        %called as 1 / 0
%4> self().
%<0.63.0>
%5> ls().
%...

%ok
%6> pwd().
%/Users/melindatoth
%ok
%7> cd().
%** exception error: undefined shell command cd/0
%8> cd("Useres/melindatoth/Desktop/dds").
%/Users/melindatoth
%ok
%9> cd("Users/melindatoth/Desktop/dds"). 
%/Users/melindatoth
%ok
%10> cd("/Users/melindatoth/Desktop/dds").
%/Users/melindatoth/Desktop/dds
%ok
%11> pwd().
%/Users/melindatoth/Desktop/dds
%ok
%12> c(first).
%{ok,first}
%13> first:module_info().
%[{module,first},
 %{exports,[{module_info,0},{module_info,1}]},
 %{attributes,[{vsn,[2801441286791094333642441933099910335]}]},
 %{compile,[{options,[]},
           %{version,"7.1"},
           %{source,"/Users/melindatoth/Desktop/dds/first.erl"}]},
 %{native,false},
 %{md5,<<2,27,137,184,38,151,51,17,168,51,71,27,46,16,68,
        %191>>}]
%14> l(first).           
%{module,first}
%15> c(first).           
%first.erl:3: Warning: function fact/1 is unused
%{ok,first}
%16> c(first).
%first.erl:3: Warning: function fact/1 is unused
%{ok,first}
%17> first:fact(1).
%** exception error: undefined function first:fact/1
%18> c(first).     
%{ok,first}
%19> first:fact(1).
%1
%20> first:fact(6).
%720
%21> first:fact(). 
%"Hello"
%22> v(20) * 2.          
%1440
%23> e(20).    
%720
%24> 1/0.
%** exception error: an error occurred when evaluating an arithmetic expression
     %in operator  '/'/2
        %called as 1 / 0
%25> e(24).
%** exception error: an error occurred when evaluating an arithmetic expression
     %in operator  '/'/2
        %called as 1 / 0
%26> v(24).
%{'EXIT',{badarith,[{erlang,'/',[1,0],[]},
                   %{erl_eval,do_apply,6,[{file,"erl_eval.erl"},{line,674}]},
                   %{shell,exprs,7,[{file,"shell.erl"},{line,687}]},
                   %{shell,eval_exprs,7,[{file,"shell.erl"},{line,642}]},
                   %{shell,eval_loop,3,[{file,"shell.erl"},{line,627}]}]}}
%27> X = first:fact(10).
%3628800
%28> X.
%3628800
%29> X = X + 2.
%** exception error: no match of right hand side value 3628802
%30> Y = 0.
%0
%31> Y = 2.
%** exception error: no match of right hand side value 2
%32> 0 = 2.
%** exception error: no match of right hand side value 2
%33> f(Y).
%ok
%34> Y = 2.
%2
%35> x.
%x
%36> x = 3.
%** exception error: no match of right hand side value 3
%37> 1.
%1
%38> 1.3.
%1.3
%39> 1 + 2.
%3
%40> erlang:'+'(1,2).
%3
%41> atom.
%atom
%42> atomHHJK23.
%atomHHJK23
%43> atomHHJK23+*.
%* 1: syntax error before: '*'
%43> 'atomHHJK23+*'.
%'atomHHJK23+*'
%44> 'atomHHJK23  +*'.
%'atomHHJK23  +*'
%45> 1 == 2.
%false
