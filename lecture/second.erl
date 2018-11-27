-module(second).
-export([print/1]).

print(Name) ->
	A = io:format("Hello\n"),
	%A = io:format("Hello " ++ Name ++ "\n"),
	B = io:format("Hello ~p\n", [Name]),
	[A, B].%,
	%1.

foo() ->
	1,
	3,
	3+4,
	7.
	
	%Last login: Mon Sep 17 08:35:19 on ttys000
%Melindas-MacBook-Pro:~ melindatoth$ erl
%Erlang/OTP 20 [erts-9.0] [source] [64-bit] [smp:4:4] [ds:4:4:10] [async-threads:10] [hipe] [kernel-poll:false] [dtrace]

%Hello
%Eshell V9.0  (abort with ^G)
%1> io:format("Hello").
%Hellook
%2> io:format("Hello\n").
%Hello
%ok
%3> ok == io:format("Hello\n").
%Hello
%true
%4> ok = io:format("Hello\n"). 
%Hello
%ok
%5> pwd().
%/Users/melindatoth
%ok
%6> cd("/Useres/melindatoth/Desktop/dds").
%/Users/melindatoth
%ok
%7> cd("/Users/melindatoth/Desktop/dds"). 
%/Users/melindatoth/Desktop/dds
%ok
%8> pwd().
%/Users/melindatoth/Desktop/dds
%ok
%9> c(second).
%{ok,second}
%10> second:print("Melinda").
%Hello
%Hello "Melinda"
%ok
%11> c(second).              
%{ok,second}
%12> second:print("Melinda").
%Hello
%Hello "Melinda"
%[ok,ok]
%13> c(second).              
%second.erl:8: Warning: a term is constructed, but never used
%{ok,second}
%14> second:print("Melinda").
%Hello
%Hello Melinda
%Hello "Melinda"
%1
%15> c(second).              
%second.erl:8: Warning: a term is constructed, but never used
%{ok,second}
%16> second:print(111).      
%Hello
%Hello 111
%1
%17> c(second).        
%second.erl:8: Warning: a term is constructed, but never used
%{ok,second}
%18> second:print(111).
%Hello
%** exception error: bad argument
     %in operator  ++/2
        %called as 111 ++ "\n"
     %in call from second:print/1 (second.erl, line 6)
%19> c(second).        
%second.erl:8: Warning: a term is constructed, but never used
%{ok,second}
%20> Tuple = {1,2,3,4}.
%{1,2,3,4}
%21> element(3, Tuple).
%3
%22> {E1, E2, E3, E4} = Tuple.
%{1,2,3,4}
%23> {_, _, E3, _} = Tuple.   
%{1,2,3,4}
%24> E3.
%3
%25> setelement(3, 12, Tuple).
%** exception error: bad argument
     %in function  setelement/3
        %called as setelement(3,12,{1,2,3,4})
%26> setelement(3, Tuple, 12).
%{1,2,12,4}
%27> Tuple.
%{1,2,3,4}
%28> "ab".
%"ab"
%29> "ab" == [a, b].
%false
%30> "ab" == [$a, $b]. 
%true
%31> $a.
%97
%32> "ab" == ["a", "b"].
%false
%33> 'dsjhgJHD  +++ .'
%33> .
%'dsjhgJHD  +++ .'
%34> 'a'.
%a
%35> 'a'== a.
%true
%36> list_to_atom("ab").
%ab
%37> "ab" == ["a", "b"].
%false
%38> "ab" == [$a, $b].  
%true
%39> $a.
%97
%40> "ab" == [97, 98].
%true
%41> String = "abcd".
%"abcd"
%42> List = [3,4,5,6, atom, {}, {3,4}].
%[3,4,5,6,atom,{},{3,4}]
%43> [add, extra, begin | List].
%* 1: syntax error before: '|'
%43> [add, extra, beginhhh | List].
%[add,extra,beginhhh,3,4,5,6,atom,{},{3,4}]
%44> List.
%[3,4,5,6,atom,{},{3,4}]
%45> [1| List].                    
%[1,3,4,5,6,atom,{},{3,4}]
%46> [ First | Rest] = List.
%[3,4,5,6,atom,{},{3,4}]
%47> First.
%3
%48> Rest.
%[4,5,6,atom,{},{3,4}]
%49> [ First, Second | Rest2] = List.
%[3,4,5,6,atom,{},{3,4}]
%50> First.
%3
%51> Second.
%4
%52> Rest2.
%[5,6,atom,{},{3,4}]
%53> String = "abcd".                  
%"abcd"
%54> [ W | _] = String.
%"abcd"
%55> W.
%97
%56> [ 97 | _] = String.
%"abcd"
%57> [ $a | _] = String.
%"abcd"
%58> string.
%string
%59> "string"
%59> .
%"string"
%60> [ $a | Rest3] = String.
%"abcd"
%61> [ $a | _] == String.   
%* 1: variable '_' is unbound
%62> [ $a | _] == "jsgdhjfd".
%* 1: variable '_' is unbound
%63> .
%* 1: syntax error before: '.'
%63> [ $a | _] = "jsgdhjfd". 
%** exception error: no match of right hand side value "jsgdhjfd"
%64> [1,2].
%[1,2]
%65> [1,2] == [1|[2]].
%true
%66> [1,2] == [1|[2 | []]].
%true
%67> [1,2] == [1, 2 | []]. 
%true
%68> [1 | atom].          
%[1|atom]
%69> [1,3,3 | atom].
%[1,3,3|atom]
%70> Tail = io:format("Hello").
%Hellook
%71> [1,2 | Tail]
%71> .
%[1,2|ok]
%72> make_ref().
%#Ref<0.3554656981.24379394.262041>
%73> second:print("Melinda").
%Hello
%Hello "Melinda"
%1
%74> second:print/1.         
%* 1: illegal expression
%75> fun second:print/1.
%#Fun<second.print.1>
%76> Fun = fun second:print/1.
%#Fun<second.print.1>
%77> Fun.
%#Fun<second.print.1>
%78> Fun("Melinda").
%Hello
%Hello "Melinda"
%1
%79> fun(X) -> X +2 end.      
%#Fun<erl_eval.6.99386804>
%80> Q = fun(X) -> X +2 end.
%#Fun<erl_eval.6.99386804>
%81> Q(12).
%14
%82> fun(X) -> second:print(X) end.
%#Fun<erl_eval.6.99386804>
%83> Fun = fun second:print/1.     
%#Fun<second.print.1>
%84> {}.
%{}
%85> #{}.
%#{}
%86> [{apple, 2}, {plum, 3}, {orange, 23}].
%[{apple,2},{plum,3},{orange,23}]
%87> #{apple=>2}.                          
%#{apple => 2}
%88> #{apple=>2, plum => 4}.
%#{apple => 2,plum => 4}
%89> M = #{apple=>2, plum => 4}.
%#{apple => 2,plum => 4}
%90> M#{apple=>22}.             
%#{apple => 22,plum => 4}
%91> #{apple:=Value}.
%* 1: only association operators '=>' are allowed in map construction
%92> #{apple:=Value} = M.
%#{apple => 2,plum => 4}
%93> Value.
%2
%94> 

