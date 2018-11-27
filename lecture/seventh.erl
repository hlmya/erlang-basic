-module(seventh).
-compile(export_all).

run(N) ->
	lists:foreach(fun(_) -> spawn(fun task/0) end, lists:seq(1, N)).
	
task() ->
	%io:format("MyPid: ~p~n", [self()]).
	0.
	
fib(0) ->
	1;
fib(1) ->
	1;
fib(N) ->
	fib(N-1) + fib(N-2).
	
call(List) ->
	lists:map(fun fib/1, List).
	
call_par(List) ->
	MyPid = self(),
	lists:map(fun(X) -> spawn(fun() -> MyPid ! sixth:fib(X) end) end, List),
	lists:map(fun(_X) -> receive
							A -> A
						 end
			  end, List).
			  
call_par_ord(List) ->
	MyPid = self(),
	lists:map(fun(X) -> spawn(fun() -> MyPid ! {X, sixth:fib(X)} end) end, List),
	lists:map(fun(X) -> receive
							{X, A}  -> A
						 end
				end, List).

par_map_ord(F, List) ->
	MyPid = self(),
	Pids = lists:map(fun(X) -> spawn(fun() -> MyPid ! {self(), F(X)} end) end, List),
	lists:map(fun(Pid) -> receive
							{Pid, A}  -> A
						 end
				end, Pids).

	%receive
		%%1 -> 1;
		%%Apple when is_atom(Apple)-> atom;
		%Value -> Value
	%end.

%Last login: Mon Nov  5 12:13:38 on ttys000
%Melindas-MacBook-Pro:~ melindatoth$ cd Desktop/dds
%Melindas-MacBook-Pro:dds melindatoth$ erl
%Erlang/OTP 20 [erts-9.0] [source] [64-bit] [smp:4:4] [ds:4:4:10] [async-threads:10] [hipe] [kernel-poll:false] [dtrace]

%Hello Melinda
%Eshell V9.0  (abort with ^G)
%1> processes().
%[<0.0.0>,<0.1.0>,<0.2.0>,<0.3.0>,<0.6.0>,<0.32.0>,<0.33.0>,
 %<0.35.0>,<0.36.0>,<0.37.0>,<0.38.0>,<0.40.0>,<0.41.0>,
 %<0.42.0>,<0.43.0>,<0.44.0>,<0.45.0>,<0.46.0>,<0.47.0>,
 %<0.48.0>,<0.49.0>,<0.50.0>,<0.51.0>,<0.52.0>,<0.53.0>,
 %<0.54.0>,<0.55.0>,<0.59.0>,<0.60.0>]
%2> observer:start().
%ok
%3> apply(fun() -> 1 + 2 end).
%** exception error: undefined shell command apply/1
%4> apply(fun() -> 1 + 2 end, []).   
%3
%5> apply(fun() -> 1/0 end, []).  
%** exception error: an error occurred when evaluating an arithmetic expression
     %in operator  '/'/2
        %called as 1 / 0
%6> self().
%<0.14281.0>
%7> apply(fun() -> 1/0 end, []).
%** exception error: an error occurred when evaluating an arithmetic expression
     %in operator  '/'/2
        %called as 1 / 0
%8> self().                     
%<0.14687.0>
%9> spawn(fun() -> 1+0 end, []).
%** exception error: bad argument
     %in function  spawn/2
        %called as spawn(#Fun<erl_eval.20.99386804>,[])
%10> spawn(fun() -> 1+0 end).    
%<0.16081.0>
%11> self().                     
%<0.15823.0>
%12> spawn(fun() -> 1/0 end).
%<0.18309.0>
%13> 
%=ERROR REPORT==== 6-Nov-2018::09:01:43 ===
%Error in process <0.18309.0> with exit value:
%{badarith,[{erlang,'/',[1,0],[]}]}

%13> self().                 
%<0.15823.0>
%14> Pid = self().           
%<0.15823.0>
%15> spawn(fun() -> Pid ! 1+0 end).
%<0.30471.0>
%16> flush().
%Shell got 1
%ok
%17> spawn(fun() -> Pid ! 1+0 end).
%<0.31128.0>
%18> spawn(fun() -> Pid ! 1+0 end).
%<0.31151.0>
%19> spawn(fun() -> Pid ! 1+0 end).
%<0.31178.0>
%20> flush().                      
%Shell got 1
%Shell got 1
%Shell got 1
%ok
%21> c(seventh).
%seventh.erl:19: syntax error before: ')'
%seventh.erl:2: Warning: export_all flag enabled - all functions will be exported 
%error
%22> c(seventh).
%seventh.erl:2: Warning: export_all flag enabled - all functions will be exported 
%{ok,seventh}                            
%23> seventh:call_par([2,3,4]).
%[2,3,5]
%24> seventh:call([2,3,4]).    
%[2,3,5]
%25> timer:tc(seventh, call, [31,23,36,23,35]).
%** exception error: undefined function seventh:call/5
     %in function  timer:tc/3 (timer.erl, line 197)
%26> timer:tc(seventh, call, [[31,23,36,23,35]]).
%{1196979,[2178309,46368,24157817,46368,14930352]}
%27> timer:tc(seventh, call_par, [[31,23,36,23,35]]).
%{734712,[46368,46368,2178309,14930352,24157817]}
%28> c(seventh).                                     
%seventh.erl:2: Warning: export_all flag enabled - all functions will be exported 
%{ok,seventh}
%29> timer:tc(seventh, call_par_ord, [[31,23,36,23,35]]).
%{700572,[2178309,46368,24157817,46368,14930352]}
%30> c(seventh).                                         
%seventh.erl:2: Warning: export_all flag enabled - all functions will be exported 
%{ok,seventh}
%31> timer:tc(seventh, call_par_ord2, [[31,23,36,23,35]]).
%{713245,[2178309,46368,24157817,46368,14930352]}
%32> c(seventh).                                          
%seventh.erl:2: Warning: export_all flag enabled - all functions will be exported 
%{ok,seventh}
%33> c(seventh).                                          
%seventh.erl:2: Warning: export_all flag enabled - all functions will be exported 
%{ok,seventh}
%34> timer:tc(seventh, run, [10]).
%** exception error: seventh:'-run/1-fun-1-'/0 called with one argument
     %in function  lists:foreach/2 (lists.erl, line 1338)
     %in call from timer:tc/3 (timer.erl, line 197)
%35> timer:tc(seventh, run, [10]).
%** exception error: seventh:'-run/1-fun-1-'/0 called with one argument
     %in function  lists:foreach/2 (lists.erl, line 1338)
     %in call from timer:tc/3 (timer.erl, line 197)
%36> c(seventh).                  
%seventh.erl:2: Warning: export_all flag enabled - all functions will be exported 
%{ok,seventh}
%37> timer:tc(seventh, run, [10]).
%MyPid: <0.15159.3>
%MyPid: <0.15160.3>
%MyPid: <0.15161.3>
%MyPid: <0.15162.3>
%MyPid: <0.15163.3>
%MyPid: <0.15164.3>
%MyPid: <0.15165.3>
%MyPid: <0.15166.3>
%MyPid: <0.15167.3>
%MyPid: <0.15168.3>
%{32,ok}

%39> timer:tc(seventh, run, [10000]).
%....

%41> erlang:system_info(process_limit).
%262144
%42> 
%BREAK: (a)bort (c)ontinue (p)roc info (i)nfo (l)oaded
       %(v)ersion (k)ill (D)b-tables (d)istribution
%^CMelindas-MacBook-Pro:dds melindatoth$ erl +P 10000000
%Erlang/OTP 20 [erts-9.0] [source] [64-bit] [smp:4:4] [ds:4:4:10] [async-threads:10] [hipe] [kernel-poll:false] [dtrace]

%Hello Melinda
%Eshell V9.0  (abort with ^G)
%1> erlang:system_info(process_limit).
%16777216
%2> timer:tc(seventh, ).
%* 1: syntax error before: ')'
%2> c(seventh).
%seventh.erl:2: Warning: export_all flag enabled - all functions will be exported 
%{ok,seventh}
%3> timer:tc(seventh, run, [1000000]).
%{1679987,ok}
%4> 
