-module(skeletons).
-compile(export_all).

taskfarm(F, List) ->
	K = erlang:system_info(logical_processors),
	Collector = spawn(fun() -> collector([]) end),
	Dispatcher = spawn(fun() -> dispatcher(List) end),
	lists:foreach(fun(_) -> 
					spawn(fun() -> worker({Collector, Dispatcher, F}) end) 
				  end, lists:seq(1, K)).

dispatcher([]) ->
	receive
		{restart, NewList} ->
			dispatcher(NewList)
	end;
dispatcher([Data|Tail]) ->
	receive
		{ready, Worker} ->
			Worker ! Data,
			dispatcher(Tail)
	end.

collector(Acc) ->
	receive
		{result, Pid} ->
			Pid ! Acc,
			collector(Acc);
		Result -> 
			collector([Result|Acc])
	end.

worker({Collector, Dispatcher, F} = Args) ->
	Dispatcher ! {ready, self()},
	receive
		Data ->  
			Collector ! F(Data),
			worker(Args)
	end.

run(N) ->
	MyPid = self(),
	Last = lists:foldl(fun(_, PrevPid) -> 
							spawn(fun() -> task(PrevPid) end)
					   end, MyPid, lists:seq(1, N)),
	Last ! ok,
	receive
		ok -> "end of the ring"
	end.
	
task(Prev) ->
	receive
		ok -> Prev ! ok
	end.
	
fib(0) ->
	1;
fib(1) ->
	1;
fib(N) ->
	fib(N-1) + fib(N-2).
	
	
Last login: Mon Nov 12 08:28:53 on ttys001
Melindas-MacBook-Pro:~ melindatoth$ cd Desktop/dds
Melindas-MacBook-Pro:dds melindatoth$ elr
-bash: elr: command not found
Melindas-MacBook-Pro:dds melindatoth$ erl
Erlang/OTP 20 [erts-9.0] [source] [64-bit] [smp:4:4] [ds:4:4:10] [async-threads:10] [hipe] [kernel-poll:false] [dtrace]

Hello Melinda
Eshell V9.0  (abort with ^G)
1> c(skeleton).
{error,non_existing}
2> c(skeletons).
skeletons.erl:2: Warning: export_all flag enabled - all functions will be exported
{ok,skeletons}
3> skeletons:run(10).
"end of the ring"
4> timer:tc(skeletons, run, [10000]).
{50473,"end of the ring"}
5> 
BREAK: (a)bort (c)ontinue (p)roc info (i)nfo (l)oaded
       (v)ersion (k)ill (D)b-tables (d)istribution
^CMelindas-MacBook-Pro:dds melindatoth$ erl +P 10000000
Erlang/OTP 20 [erts-9.0] [source] [64-bit] [smp:4:4] [ds:4:4:10] [async-threads:10] [hipe] [kernel-poll:false] [dtrace]

Hello Melinda
Eshell V9.0  (abort with ^G)
1> timer:tc(skeletons, run, [100000]).
{518158,"end of the ring"}
2> observer:start().
ok
3> timer:tc(skeletons, run, [1000000]).
{8332266,"end of the ring"}
4> erlang:system_info(logical_processors).
4
5> erlang:system_info(logical_processors_available).
unknown
6> erlang:system_info(logical_processors_online).   
4
7> erlang:system_info(logical_processors).          
4
8> c(skeletons).                                    
skeletons.erl:9: syntax error before: ')'
skeletons.erl:35: function worker/1 undefined
skeletons.erl:2: Warning: export_all flag enabled - all functions will be exported
error
9> c(skeletons).
skeletons.erl:35: function worker/1 undefined
skeletons.erl:2: Warning: export_all flag enabled - all functions will be exported
error
10> c(skeletons).
skeletons.erl:2: Warning: export_all flag enabled - all functions will be exported
{ok,skeletons}
11> c(skeletons).
skeletons.erl:2: Warning: export_all flag enabled - all functions will be exported
{ok,skeletons}
12> skeletons:taskfarm(fun skeletons:fib/1, [1,2,3,4,5,6]).
ok
13> exit(<0.267776.33>, kill).
* 1: syntax error before: '<'
13> exit(<0.26776.33>, kill). 
true
14> exit(<0.26777.33>, kill).
true
15> exit(<0.26772.33>, kill).
true
16> c(skeletons).                                          
skeletons.erl:2: Warning: export_all flag enabled - all functions will be exported
{ok,skeletons}
17> skeletons:taskfarm(fun skeletons:fib/1, [1,2,3,4,5,6]).
ok
18> <0.2023.34> ! {result, self()}.
{result,<0.60.0>}
19> flush().
Shell got [13,8,5,3,2,1]
ok
20> skeletons:taskfarm(fun skeletons:fib/1, [1,2,3,4,5,6, ""]).
ok
21> 
=ERROR REPORT==== 13-Nov-2018::09:51:11 ===
Error in process <0.5834.34> with exit value:
{badarith,[{skeletons,fib,1,[{file,"skeletons.erl"},{line,56}]},
           {skeletons,worker,1,[{file,"skeletons.erl"},{line,37}]}]}

21> spawn(fun() -> 1/0 end).

=ERROR REPORT==== 13-Nov-2018::09:53:04 ===
Error in process <0.8411.34> with exit value:
{badarith,[{erlang,'/',[1,0],[]}]}
<0.8411.34>
22> self().
<0.60.0>
23> spawn(fun() -> 1/0 end).

=ERROR REPORT==== 13-Nov-2018::09:53:19 ===
Error in process <0.8597.34> with exit value:
{badarith,[{erlang,'/',[1,0],[]}]}
<0.8597.34>
24> spawn(fun() -> 1/0 end).

=ERROR REPORT==== 13-Nov-2018::09:53:24 ===
Error in process <0.8782.34> with exit value:
{badarith,[{erlang,'/',[1,0],[]}]}
<0.8782.34>
25> self().                 
<0.60.0>
26> spawn_link(fun() -> 1/0 end).

=ERROR REPORT==== 13-Nov-2018::09:54:07 ===
Error in process <0.9517.34> with exit value:
{badarith,[{erlang,'/',[1,0],[]}]}
** exception exit: badarith
     in operator  '/'/2
        called as 1 / 0
27> self().
<0.9518.34>
28> process_flag(trap_exit, true).
false
29> spawn_link(fun() -> 1/0 end). 

=ERROR REPORT==== 13-Nov-2018::09:56:26 ===
Error in process <0.12084.34> with exit value:
{badarith,[{erlang,'/',[1,0],[]}]}
<0.12084.34>
30> self().
<0.9518.34>
31> flush().
Shell got {'EXIT',<0.12084.34>,{badarith,[{erlang,'/',[1,0],[]}]}}
ok
32> spawn_link(fun() -> 1/0 end).

=ERROR REPORT==== 13-Nov-2018::09:58:02 ===
Error in process <0.13918.34> with exit value:
{badarith,[{erlang,'/',[1,0],[]}]}
<0.13918.34>
33> spawn_link(fun() -> 1/1 end).
<0.13920.34>
34> flush().                     
Shell got {'EXIT',<0.13918.34>,{badarith,[{erlang,'/',[1,0],[]}]}}
Shell got {'EXIT',<0.13920.34>,normal}
ok
35> 

