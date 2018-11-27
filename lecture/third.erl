-module(third).
-compile(export_all).

%% DO NOT USE THIS: 
%% count(_X, L) when length(L) == 0 ->
%% count(_X, L) when L == [] ->
count(_X, []) -> 
	0;
count(X, [X | T]) -> %% when guard(X, X) -> % when H == X ->
	1 + count(X, T);
count(X, [_|T]) ->
	count(X, T).

guard(A,B) ->
	A == B.
	
count([]) ->
	0;
count([$p | T]) ->
	1 + count(T);
count([_H|T]) ->
	count(T).

%count([]) ->
	%0;
%count([H | T]) when H == $p ->
	%1 + count(T);
%count([_H|T]) ->
	%count(T).

use(N) when is_integer(N) ->
	fact(N) + fact(N).
	
fact(0) -> 1;
fact(N) when is_integer(N), N > 0-> 
	N * fact(N-1);
fact(_) ->
	bad_argument.

%Last login: Mon Sep 24 16:54:53 on ttys002
%Melindas-MacBook-Pro:~ melindatoth$ erl
%Erlang/OTP 20 [erts-9.0] [source] [64-bit] [smp:4:4] [ds:4:4:10] [async-threads:10] [hipe] [kernel-poll:false] [dtrace]

%Hello
%Eshell V9.0  (abort with ^G)
%1> <<>>.
%<<>>
%2> <<1,2>>.
%<<1,2>>
%3> <<1:4,2:4>>.
%<<18>>
%4> <<1:4,2:4, 3:4>>.
%<<18,3:4>>
%5> <<1:2,2:2,3:2>>. 
%<<27:6>>
%6> <<1:2,2:2,3:2,1:2>>.
%<<"m">>
%7> $m.
%109
%8> Bin = <<1:4,2:4, 3:4>>.
%<<18,3:4>>
%9> << Byte, Res:4>> = Bin.
%<<18,3:4>>
%10> << Bit2:2, Bit22:4, Res2/bitsring>> = Bin.
%* 1: bit type bitsring undefined
%11> << Bit2:2, Bit22:4, Res2/bitstring>> = Bin. 
%<<18,3:4>>
%12> Bit2.
%0
%13> Bit22.
%4
%14> Res2.
%<<35:6>>
%15> 1 == 1.0.
%true
%16> 1 =:= 1.0.
%false
%17> 1 < atom.
%true
%18> 1 < "sadhhhd"
%18> .
%true
%19> [1,2, atom] < [1, atom, 3].
%true
%20> [1,2, atom] < [].          
%false
%21> {1,2, atom} < {1, atom, 3}.
%true
%22> {1,2, atom} < {}.          
%false
%23> {1,2, atom} > {}.
%true
%24> {1,2, atom} > {11, atom, 3}.
%false
%25> {1,2, atom} > {}.           
%true
%26> [] > {}.
%true
%27> is_integer(Bin).
%false
%28> Bin.
%<<18,3:4>>
%29> is_integer(23). 
%true
%30> pwd().
%/Users/melindatoth
%ok
%31> cd("/Users/melindatoth/Desktop/dds").
%/Users/melindatoth/Desktop/dds
%ok
%32> c(third).
%third.erl:2: Warning: export_all flag enabled - all functions will be exported
%{ok,third}
%33> third:fact(12).
%479001600
%34> third:fact(apple).
%** exception error: an error occurred when evaluating an arithmetic expression
     %in function  third:fact/1 (third.erl, line 4)
%35> third:fact("apple").
%** exception error: an error occurred when evaluating an arithmetic expression
     %in function  third:fact/1 (third.erl, line 4)
%36> c(third).           
%third.erl:2: Warning: export_all flag enabled - all functions will be exported
%{ok,third}
%37> third:fact("apple").
%** exception error: no function clause matching third:fact("apple") (third.erl, line 4)
%38> c(third).           
%third.erl:2: Warning: export_all flag enabled - all functions will be exported
%{ok,third}
%39> third:fact("apple").
%bad_argument
%40> c(third).           
%third.erl:2: Warning: export_all flag enabled - all functions will be exported
%{ok,third}
%41> third:use("apple"). 
%** exception error: an error occurred when evaluating an arithmetic expression
     %in function  third:use/1 (third.erl, line 5)
%42> c(third).           
%third.erl:2: Warning: export_all flag enabled - all functions will be exported
%{ok,third}
%43> third:fact(-2).    
%bad_argument
%44> c(third).      
%third.erl:2: Warning: export_all flag enabled - all functions will be exported
%{ok,third}
%45> third:count([]).
%0
%46> third:count("ppp").
%3
%47> third:count("phjpp").
%** exception error: no function clause matching third:count("hjpp") (third.erl, line 4)
     %in function  third:count/1 (third.erl, line 7)
%48> c(third).            
%third.erl:2: Warning: export_all flag enabled - all functions will be exported
%third.erl:8: Warning: variable 'H' is unused
%{ok,third}
%49> c(third).
%third.erl:2: Warning: export_all flag enabled - all functions will be exported
%{ok,third}
%50> third:count("phjpp").
%3
%51> X = 1.
%1
%52> {X, Y} = {1, 2}.
%{1,2}
%53> {X, 3} = {1, 2}.
%** exception error: no match of right hand side value {1,2}
%54> {X, 2} = {1, 2}.
%{1,2}
%55> [$a|_] = "apple".
%"apple"
%56> [$a|_] = "pple". 
%** exception error: no match of right hand side value "pple"
%57> c(third).            
%third.erl:2: Warning: export_all flag enabled - all functions will be exported
%{ok,third}
%58> third:count("phjpp").
%3
%59> c(third).            
%third.erl:2: Warning: export_all flag enabled - all functions will be exported
%{ok,third}
%60> third:count("phjpp", $a).
%0
%61> third:count("phjpp", $p).
%3
%62> third:count("phjpp", $j).
%1
%63> third:count([34,143,123,12,12,1], 12).
%2
%64> third:count(12, [12,13,1]).           
%** exception error: no function clause matching third:count(12,[12,13,1]) (third.erl, line 4)
%65> c(third).                             
%third.erl:2: Warning: export_all flag enabled - all functions will be exported
%{ok,third}
%66> third:count(12, [12,13,1]).
%1
%67> c(third).                  
%third.erl:9: call to local/imported function guard/2 is illegal in guard
%third.erl:2: Warning: export_all flag enabled - all functions will be exported
%error
%68> debugger:start().
%{ok,<0.183.0>}
%69> 
