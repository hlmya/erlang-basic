-module(skeletons2).
-compile(export_all).

taskfarm(F, List) ->
	K = erlang:system_info(logical_processors),
	register(collector, spawn(fun() -> collector([]) end)),
	D = spawn(fun() -> dispatcher(List) end),
	register(dispatcher, D),
	WorkerFun = fun() -> worker(F) end,
	Workers = lists:map(fun(_) -> 
							spawn(WorkerFun) 
						end, lists:seq(1, K)),
	spawn(fun() -> supervise_init(Workers, WorkerFun) end).
	
supervise_init(Workers, WorkerFun) ->
	Refs = lists:map(fun(W) -> {W, monitor(process, W)} end, Workers),
	supervise(Refs, WorkerFun).

supervise(Refs, WorkerFun) -> 
	receive
		{'DOWN', Ref, process, Pid, Reason} when Reason/=normal->
			case lists:member({Pid, Ref}, Refs) of
				true ->
					io:format("Worker terminated~n"),
					NewRef = spawn_monitor(WorkerFun),
					supervise([NewRef | lists:delete({Pid, Ref}, Refs)], WorkerFun);
				false ->
					io:format("Smb terminated~n"),
					supervise(Refs, WorkerFun)
			end
	end.

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

worker(F) ->
	dispatcher ! {ready, self()},
	receive
		Data ->  
			collector ! F(Data),
			worker(F)
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
	
Last login: Mon Nov 19 12:29:50 on ttys003
Melindas-MacBook-Pro:~ melindatoth$ cd Desktop/dds
Melindas-MacBook-Pro:dds melindatoth$ erl
Erlang/OTP 20 [erts-9.0] [source] [64-bit] [smp:4:4] [ds:4:4:10] [async-threads:10] [hipe] [kernel-poll:false] [dtrace]

Hello Melinda
Eshell V9.0  (abort with ^G)
1> spawn(fun() -> 1/0 end).
<0.62.0>
2> 
=ERROR REPORT==== 20-Nov-2018::08:35:58 ===
Error in process <0.62.0> with exit value:
{badarith,[{erlang,'/',[1,0],[]}]}

2> spawn_link(fun() -> 1/0 end).

=ERROR REPORT==== 20-Nov-2018::08:36:15 ===
Error in process <0.64.0> with exit value:
{badarith,[{erlang,'/',[1,0],[]}]}
** exception exit: badarith
     in operator  '/'/2
        called as 1 / 0
3> self().                      
<0.65.0>
4> spawn_link(fun() -> 1/0 end).

=ERROR REPORT==== 20-Nov-2018::08:36:42 ===
Error in process <0.68.0> with exit value:
{badarith,[{erlang,'/',[1,0],[]}]}
** exception exit: badarith
     in operator  '/'/2
        called as 1 / 0
5> self().                      
<0.69.0>
6> process_flag(trap_exit, true).
false
7> spawn_link(fun() -> 1/0 end). 

=ERROR REPORT==== 20-Nov-2018::08:38:35 ===
Error in process <0.73.0> with exit value:
{badarith,[{erlang,'/',[1,0],[]}]}
<0.73.0>
8> self().                       
<0.69.0>
9> flush().
Shell got {'EXIT',<0.73.0>,{badarith,[{erlang,'/',[1,0],[]}]}}
ok
10> spawn_link(fun() -> 1/1 end).
<0.77.0>
11> flush().                     
Shell got {'EXIT',<0.77.0>,normal}
ok
12> spawn_monitor(fun() -> 1/1 end).
{<0.80.0>,#Ref<0.2678879081.1479278593.65671>}
13> flush().                        
Shell got {'DOWN',#Ref<0.2678879081.1479278593.65671>,process,<0.80.0>,normal}
ok
14> self() ! {'EXIT', <0.80.0>, normal}.
{'EXIT',<0.80.0>,normal}
15> flush().                            
Shell got {'EXIT',<0.80.0>,normal}
ok
16> make_ref().
#Ref<0.2678879081.1479278593.65694>
17> spawn_monitor(fun() -> 1/0 end).    

=ERROR REPORT==== 20-Nov-2018::08:58:45 ===
Error in process <0.86.0> with exit value:
{badarith,[{erlang,'/',[1,0],[]}]}
{<0.86.0>,#Ref<0.2678879081.1479278593.65699>}
18> flush().                        
Shell got {'DOWN',#Ref<0.2678879081.1479278593.65699>,process,<0.86.0>,
                  {badarith,[{erlang,'/',[1,0],[]}]}}
ok
19> observer:start().
ok
20> spawn_monitor(fun() -> 1/0 end).

=ERROR REPORT==== 20-Nov-2018::09:25:16 ===
Error in process <0.114.0> with exit value:
{badarith,[{erlang,'/',[1,0],[]}]}
{<0.114.0>,#Ref<0.2678879081.1479278593.67182>}
21> spawn_monitor(fun() -> 1/1 end).
{<0.116.0>,#Ref<0.2678879081.1479278593.67211>}
22> processes().                    
[<0.0.0>,<0.1.0>,<0.2.0>,<0.3.0>,<0.6.0>,<0.32.0>,<0.33.0>,
 <0.35.0>,<0.36.0>,<0.37.0>,<0.38.0>,<0.40.0>,<0.41.0>,
 <0.42.0>,<0.43.0>,<0.44.0>,<0.45.0>,<0.46.0>,<0.47.0>,
 <0.48.0>,<0.49.0>,<0.50.0>,<0.51.0>,<0.52.0>,<0.53.0>,
 <0.54.0>,<0.55.0>,<0.59.0>,<0.69.0>|...]
23> monitor(process, <0.38.0>).
#Ref<0.2678879081.1479278593.67397>
24> c(skeletons2).
skeletons2.erl:2: Warning: export_all flag enabled - all functions will be exported
{ok,skeletons2}
25> c(skeletons2).                              
skeletons2.erl:2: Warning: export_all flag enabled - all functions will be exported
{ok,skeletons2}
26> skeletons2:taskfarm(fun skeletons2:fib/1, [2,3,4]).
<0.136.0>
27> i().
Pid                   Initial Call                          Heap     Reds Msgs
Registered            Current Function                     Stack              
<0.0.0>               otp_ring0:start/2                      376      845    0
init                  init:loop/1                              2              
<0.1.0>               erts_code_purger:start/0               233       18    0
erts_code_purger      erts_code_purger:wait_for_request        0              
<0.2.0>               erts_literal_area_collector:start      233        3    0
                      erts_literal_area_collector:msg_l        5              
<0.3.0>               erts_dirty_process_code_checker:s      233        3    0
                      erts_dirty_process_code_checker:m        1              
<0.6.0>               erlang:apply/2                        2586   905871    0
erl_prim_loader       erl_prim_loader:loop/3                   5              
<0.32.0>              gen_event:init_it/6                   2586     7893    0
error_logger          gen_event:fetch_msg/6                   10              
<0.33.0>              erlang:apply/2                        1598     8848    0
application_controlle gen_server:loop/7                        7              
<0.35.0>              application_master:init/4              233       69    0
                      application_master:main_loop/2           7              
<0.36.0>              application_master:start_it/4          233       90    0
                      application_master:loop_it/4             5              
<0.37.0>              supervisor:kernel/1                    610     2172    0
kernel_sup            gen_server:loop/7                       10              
<0.38.0>              erlang:apply/2                       75113   178224    0
code_server           code_server:loop/1                       3              
<0.40.0>              rpc:init/1                             233       32    0
rex                   gen_server:loop/7                       10              
<0.41.0>              global:init/1                          233       63    0
global_name_server    gen_server:loop/7                       10              
<0.42.0>              erlang:apply/2                         233       25    0
                      global:loop_the_locker/1                 5              
<0.43.0>              erlang:apply/2                         233        3    0
                      global:loop_the_registrar/0              2              
<0.44.0>              inet_db:init/1                         233      351    0
inet_db               gen_server:loop/7                       10              
<0.45.0>              global_group:init/1                    233       74    0
global_group          gen_server:loop/7                       10              
<0.46.0>              file_server:init/1                    1598     2250    0
file_server_2         gen_server:loop/7                       10              
<0.47.0>              gen_event:init_it/6                    233       51    0
erl_signal_server     gen_event:fetch_msg/6                   10              
<0.48.0>              supervisor_bridge:standard_error/      233       50    0
standard_error_sup    gen_server:loop/7                       10              
<0.49.0>              erlang:apply/2                         233       11    0
standard_error        standard_error:server_loop/1             2              
<0.50.0>              supervisor_bridge:user_sup/1           233       74    0
                      gen_server:loop/7                       10              
<0.51.0>              user_drv:server/2                      376    64516    0
user_drv              user_drv:server_loop/6                   9              
<0.52.0>              group:server/3                         233      270    0
user                  group:server_loop/3                      4              
<0.53.0>              group:server/3                       10958   116161    0
                      group:server_loop/3                      4              
<0.54.0>              kernel_config:init/1                   233       47    0
                      gen_server:loop/7                       10              
<0.55.0>              supervisor:kernel/1                    233      176    0
kernel_safe_sup       gen_server:loop/7                       10              
<0.59.0>              erlang:apply/2                        4185    13187    0
                      shell:shell_rep/4                       17              
<0.69.0>              erlang:apply/2                        2586    72121    2
                      c:pinfo/1                               50              
<0.89.0>              observer_wx:init/1                    6772    16486    0
observer              wx_object:loop/6                        10              
<0.90.0>              wxe_server:init/1                     1598     3139    0
                      gen_server:loop/7                       10              
<0.91.0>              wxe_master:init/1                     2586      893    0
wxe_master            gen_server:loop/7                       10              
<0.92.0>              erlang:apply/2                        1598    77667    0
                      timer:sleep/1                            5              
<0.94.0>              observer_sys_wx:init/1               10958    25875    0
                      wx_object:loop/6                        10              
<0.95.0>              timer:init/1                           610    16839    0
timer_server          gen_server:loop/7                       11              
<0.96.0>              observer_perf_wx:init/1                987     3595    0
                      wx_object:loop/6                        10              
<0.100.0>             observer_alloc_wx:init/1               376     4509    0
                      wx_object:loop/6                        10              
<0.101.0>             observer_app_wx:init/1                4185     9584    0
                      wx_object:loop/6                        10              
<0.102.0>             observer_pro_wx:init/1                 987     5257    0
                      wx_object:loop/6                        10              
<0.103.0>             erlang:apply/2                         987      842    0
                      observer_pro_wx:table_holder/1           8              
<0.105.0>             observer_port_wx:init/1                987     3383    0
                      wx_object:loop/6                        10              
<0.106.0>             observer_tv_wx:init/1                  376     3296    0
                      wx_object:loop/6                        10              
<0.107.0>             observer_trace_wx:init/1              2586    14144    0
                      wx_object:loop/6                        10              
<0.110.0>             appmon_info:init/1                    2586   556816    0
appmon_info           gen_server:loop/7                       10              
<0.130.0>             erlang:apply/2                         233        6    0
                      skeletons2:collector/1                   2              
<0.131.0>             erlang:apply/2                         233       13    4
                      skeletons2:dispatcher/1                  0              
<0.132.0>             erlang:apply/2                         233       13    0
                      skeletons2:worker/1                      4              
<0.133.0>             erlang:apply/2                         233       17    0
                      skeletons2:worker/1                      4              
<0.134.0>             erlang:apply/2                         233       25    0
                      skeletons2:worker/1                      4              
<0.135.0>             erlang:apply/2                         233        4    0
                      skeletons2:worker/1                      4              
<0.136.0>             erlang:apply/2                         233       26    0
                      skeletons2:supervise/2                   5              
Total                                                     146576  2115927    6
                                                             415              
ok
28> processes().
[<0.0.0>,<0.1.0>,<0.2.0>,<0.3.0>,<0.6.0>,<0.32.0>,<0.33.0>,
 <0.35.0>,<0.36.0>,<0.37.0>,<0.38.0>,<0.40.0>,<0.41.0>,
 <0.42.0>,<0.43.0>,<0.44.0>,<0.45.0>,<0.46.0>,<0.47.0>,
 <0.48.0>,<0.49.0>,<0.50.0>,<0.51.0>,<0.52.0>,<0.53.0>,
 <0.54.0>,<0.55.0>,<0.59.0>,<0.69.0>|...]
29> i().        
Pid                   Initial Call                          Heap     Reds Msgs
Registered            Current Function                     Stack              
<0.0.0>               otp_ring0:start/2                      376      845    0
init                  init:loop/1                              2              
<0.1.0>               erts_code_purger:start/0               233       18    0
erts_code_purger      erts_code_purger:wait_for_request        0              
<0.2.0>               erts_literal_area_collector:start      233        3    0
                      erts_literal_area_collector:msg_l        5              
<0.3.0>               erts_dirty_process_code_checker:s      233        3    0
                      erts_dirty_process_code_checker:m        1              
<0.6.0>               erlang:apply/2                        2586   905871    0
erl_prim_loader       erl_prim_loader:loop/3                   5              
<0.32.0>              gen_event:init_it/6                   2586     7893    0
error_logger          gen_event:fetch_msg/6                   10              
<0.33.0>              erlang:apply/2                        2586     8997    0
application_controlle gen_server:loop/7                        7              
<0.35.0>              application_master:init/4              233       69    0
                      application_master:main_loop/2           7              
<0.36.0>              application_master:start_it/4          233       90    0
                      application_master:loop_it/4             5              
<0.37.0>              supervisor:kernel/1                    610     2172    0
kernel_sup            gen_server:loop/7                       10              
<0.38.0>              erlang:apply/2                       75113   178231    0
code_server           code_server:loop/1                       3              
<0.40.0>              rpc:init/1                             233       32    0
rex                   gen_server:loop/7                       10              
<0.41.0>              global:init/1                          233       63    0
global_name_server    gen_server:loop/7                       10              
<0.42.0>              erlang:apply/2                         233       25    0
                      global:loop_the_locker/1                 5              
<0.43.0>              erlang:apply/2                         233        3    0
                      global:loop_the_registrar/0              2              
<0.44.0>              inet_db:init/1                         233      351    0
inet_db               gen_server:loop/7                       10              
<0.45.0>              global_group:init/1                    233       74    0
global_group          gen_server:loop/7                       10              
<0.46.0>              file_server:init/1                    1598     2250    0
file_server_2         gen_server:loop/7                       10              
<0.47.0>              gen_event:init_it/6                    233       51    0
erl_signal_server     gen_event:fetch_msg/6                   10              
<0.48.0>              supervisor_bridge:standard_error/      233       50    0
standard_error_sup    gen_server:loop/7                       10              
<0.49.0>              erlang:apply/2                         233       11    0
standard_error        standard_error:server_loop/1             2              
<0.50.0>              supervisor_bridge:user_sup/1           233       74    0
                      gen_server:loop/7                       10              
<0.51.0>              user_drv:server/2                     2586    72678    0
user_drv              user_drv:server_loop/6                   9              
<0.52.0>              group:server/3                         233      270    0
user                  group:server_loop/3                      4              
<0.53.0>              group:server/3                       10958   206524    0
                      group:server_loop/3                      4              
<0.54.0>              kernel_config:init/1                   233       47    0
                      gen_server:loop/7                       10              
<0.55.0>              supervisor:kernel/1                    233      176    0
kernel_safe_sup       gen_server:loop/7                       10              
<0.59.0>              erlang:apply/2                        4185    13707    0
                      shell:shell_rep/4                       17              
<0.69.0>              erlang:apply/2                        2586   127118    2
                      c:pinfo/1                               50              
<0.89.0>              observer_wx:init/1                    6772    16486    0
observer              wx_object:loop/6                        10              
<0.90.0>              wxe_server:init/1                     1598     3139    0
                      gen_server:loop/7                       10              
<0.91.0>              wxe_master:init/1                     2586      893    0
wxe_master            gen_server:loop/7                       10              
<0.92.0>              erlang:apply/2                        1598    78441    0
                      timer:sleep/1                            5              
<0.94.0>              observer_sys_wx:init/1               10958    25875    0
                      wx_object:loop/6                        10              
<0.95.0>              timer:init/1                           610    17125    0
timer_server          gen_server:loop/7                       11              
<0.96.0>              observer_perf_wx:init/1                987     3595    0
                      wx_object:loop/6                        10              
<0.100.0>             observer_alloc_wx:init/1               376     4509    0
                      wx_object:loop/6                        10              
<0.101.0>             observer_app_wx:init/1                4185     9584    0
                      wx_object:loop/6                        10              
<0.102.0>             observer_pro_wx:init/1                 987     5257    0
                      wx_object:loop/6                        10              
<0.103.0>             erlang:apply/2                         987      842    0
                      observer_pro_wx:table_holder/1           8              
<0.105.0>             observer_port_wx:init/1                987     3383    0
                      wx_object:loop/6                        10              
<0.106.0>             observer_tv_wx:init/1                  376     3296    0
                      wx_object:loop/6                        10              
<0.107.0>             observer_trace_wx:init/1              2586    14144    0
                      wx_object:loop/6                        10              
<0.110.0>             appmon_info:init/1                   10958   567450    0
appmon_info           gen_server:loop/7                       10              
<0.130.0>             erlang:apply/2                         233        6    0
                      skeletons2:collector/1                   2              
<0.131.0>             erlang:apply/2                         233       13    4
                      skeletons2:dispatcher/1                  0              
<0.132.0>             erlang:apply/2                         233       13    0
                      skeletons2:worker/1                      4              
<0.133.0>             erlang:apply/2                         233       17    0
                      skeletons2:worker/1                      4              
<0.134.0>             erlang:apply/2                         233       25    0
                      skeletons2:worker/1                      4              
<0.135.0>             erlang:apply/2                         233        4    0
                      skeletons2:worker/1                      4              
<0.136.0>             erlang:apply/2                         233       26    0
                      skeletons2:supervise/2                   5              
Total                                                     158146  2281819    6
                                                             415              
ok
30> fun() -> worker({Collector, Dispatcher, F}) end.
* 1: variable 'Collector' is unbound
31> <0.130.0> ! {result, self()}.
{result,<0.69.0>}
32> flush().
Shell got {'DOWN',#Ref<0.2678879081.1479278593.67182>,process,<0.114.0>,
                  {badarith,[{erlang,'/',[1,0],[]}]}}
Shell got {'DOWN',#Ref<0.2678879081.1479278593.67211>,process,<0.116.0>,
                  normal}
Shell got [5,3,2]
ok
33> <0.131.0> ! {restart, [32,32,21]}.
{restart,[32,32,21]}
34> flush().                          
ok
35> flush().
ok
36> <0.130.0> ! {result, self()}.     
{result,<0.69.0>}
37> flush().                     
Shell got [3524578,3524578,17711,5,3,2]
ok
38> <0.131.0> ! {restart, [32,32,21, 2, 3, 4, apple, plum, pear, 34, 32, 32]}.
{restart,[32,32,21,2,3,4,apple,plum,pear,34,32,32]}
Worker terminated
Worker terminated
Worker terminated
39> 
=ERROR REPORT==== 20-Nov-2018::09:39:20 ===
Error in process <0.132.0> with exit value:
{badarith,[{skeletons2,fib,1,[{file,"skeletons2.erl"},{line,76}]},
           {skeletons2,worker,1,[{file,"skeletons2.erl"},{line,57}]}]}

=ERROR REPORT==== 20-Nov-2018::09:39:20 ===
Error in process <0.150.0> with exit value:
{badarith,[{skeletons2,fib,1,[{file,"skeletons2.erl"},{line,76}]},
           {skeletons2,worker,1,[{file,"skeletons2.erl"},{line,57}]}]}

=ERROR REPORT==== 20-Nov-2018::09:39:20 ===
Error in process <0.151.0> with exit value:
{badarith,[{skeletons2,fib,1,[{file,"skeletons2.erl"},{line,76}]},
           {skeletons2,worker,1,[{file,"skeletons2.erl"},{line,57}]}]}

39> <0.130.0> ! {result, self()}.                                             
{result,<0.69.0>}
40> flush().                                                                  
Shell got [9227465,3524578,3524578,3524578,3524578,17711,5,3,2,3524578,
           3524578,17711,5,3,2]
ok
41> i().                                                                      
Pid                   Initial Call                          Heap     Reds Msgs
Registered            Current Function                     Stack              
<0.0.0>               otp_ring0:start/2                      376      845    0
init                  init:loop/1                              2              
<0.1.0>               erts_code_purger:start/0               233       18    0
erts_code_purger      erts_code_purger:wait_for_request        0              
<0.2.0>               erts_literal_area_collector:start      233        3    0
                      erts_literal_area_collector:msg_l        5              
<0.3.0>               erts_dirty_process_code_checker:s      233        3    0
                      erts_dirty_process_code_checker:m        1              
<0.6.0>               erlang:apply/2                        2586   905871    0
erl_prim_loader       erl_prim_loader:loop/3                   5              
<0.32.0>              gen_event:init_it/6                   2586    13752    0
error_logger          gen_event:fetch_msg/6                   10              
<0.33.0>              erlang:apply/2                        2586    11481    0
application_controlle gen_server:loop/7                        7              
<0.35.0>              application_master:init/4              233       69    0
                      application_master:main_loop/2           7              
<0.36.0>              application_master:start_it/4          233       90    0
                      application_master:loop_it/4             5              
<0.37.0>              supervisor:kernel/1                    610     2172    0
kernel_sup            gen_server:loop/7                       10              
<0.38.0>              erlang:apply/2                       75113   178273    0
code_server           code_server:loop/1                       3              
<0.40.0>              rpc:init/1                             233       32    0
rex                   gen_server:loop/7                       10              
<0.41.0>              global:init/1                          233       63    0
global_name_server    gen_server:loop/7                       10              
<0.42.0>              erlang:apply/2                         233       25    0
                      global:loop_the_locker/1                 5              
<0.43.0>              erlang:apply/2                         233        3    0
                      global:loop_the_registrar/0              2              
<0.44.0>              inet_db:init/1                         233      379    0
inet_db               gen_server:loop/7                       10              
<0.45.0>              global_group:init/1                    233       74    0
global_group          gen_server:loop/7                       10              
<0.46.0>              file_server:init/1                    1598     2250    0
file_server_2         gen_server:loop/7                       10              
<0.47.0>              gen_event:init_it/6                    233       51    0
erl_signal_server     gen_event:fetch_msg/6                   10              
<0.48.0>              supervisor_bridge:standard_error/      233       50    0
standard_error_sup    gen_server:loop/7                       10              
<0.49.0>              erlang:apply/2                         233       11    0
standard_error        standard_error:server_loop/1             2              
<0.50.0>              supervisor_bridge:user_sup/1           233       74    0
                      gen_server:loop/7                       10              
<0.51.0>              user_drv:server/2                     2586   109942    0
user_drv              user_drv:server_loop/6                   9              
<0.52.0>              group:server/3                         376      310    0
user                  group:server_loop/3                      4              
<0.53.0>              group:server/3                       10958   316167    0
                      group:server_loop/3                      4              
<0.54.0>              kernel_config:init/1                   233       47    0
                      gen_server:loop/7                       10              
<0.55.0>              supervisor:kernel/1                    233      176    0
kernel_safe_sup       gen_server:loop/7                       10              
<0.59.0>              erlang:apply/2                        4185    18526    0
                      shell:shell_rep/4                       17              
<0.69.0>              erlang:apply/2                        2586   181347    0
                      c:pinfo/1                               50              
<0.89.0>              observer_wx:init/1                    6772    16486    0
observer              wx_object:loop/6                        10              
<0.90.0>              wxe_server:init/1                     1598     3139    0
                      gen_server:loop/7                       10              
<0.91.0>              wxe_master:init/1                     2586      893    0
wxe_master            gen_server:loop/7                       10              
<0.92.0>              erlang:apply/2                        1598    91857    0
                      timer:sleep/1                            5              
<0.94.0>              observer_sys_wx:init/1               10958    25875    0
                      wx_object:loop/6                        10              
<0.95.0>              timer:init/1                           610    21619    0
timer_server          gen_server:loop/7                       11              
<0.96.0>              observer_perf_wx:init/1                987     3595    0
                      wx_object:loop/6                        10              
<0.100.0>             observer_alloc_wx:init/1               376     4509    0
                      wx_object:loop/6                        10              
<0.101.0>             observer_app_wx:init/1                4185     9584    0
                      wx_object:loop/6                        10              
<0.102.0>             observer_pro_wx:init/1                 987     5257    0
                      wx_object:loop/6                        10              
<0.103.0>             erlang:apply/2                         987      842    0
                      observer_pro_wx:table_holder/1           8              
<0.105.0>             observer_port_wx:init/1                987     3383    0
                      wx_object:loop/6                        10              
<0.106.0>             observer_tv_wx:init/1                  376     3296    0
                      wx_object:loop/6                        10              
<0.107.0>             observer_trace_wx:init/1              2586    14144    0
                      wx_object:loop/6                        10              
<0.110.0>             appmon_info:init/1                    4185   735059    0
appmon_info           gen_server:loop/7                       10              
<0.130.0>             erlang:apply/2                         233       24    0
                      skeletons2:collector/1                   2              
<0.131.0>             erlang:apply/2                         233       53    4
                      skeletons2:dispatcher/1                  0              
<0.133.0>             erlang:apply/2                         233 28260425    0
                      skeletons2:worker/1                      4              
<0.134.0>             erlang:apply/2                         233 14094815    0
                      skeletons2:worker/1                      4              
<0.135.0>             erlang:apply/2                         233 28260412    0
                      skeletons2:worker/1                      4              
<0.136.0>             erlang:apply/2                         233      112    0
                      skeletons2:supervise/2                   5              
<0.152.0>             erlang:apply/2                         233 36900640    0
                      skeletons2:worker/1                      4              
Total                                                     151516 11019812    4
                                                             415              
ok
42> <0.131.0> ! {restart, [32,32,21, 2, 3, 4, apple, 37, 36, plum,  37, pear, 36, 34, 32, 32]}.
{restart,[32,32,21,2,3,4,apple,37,36,plum,37,pear,36,34,32,
          32]}
Worker terminated
43> 
=ERROR REPORT==== 20-Nov-2018::09:47:00 ===
Error in process <0.152.0> with exit value:
{badarith,[{skeletons2,fib,1,[{file,"skeletons2.erl"},{line,76}]},
           {skeletons2,worker,1,[{file,"skeletons2.erl"},{line,57}]}]}
Worker terminated
43> 
=ERROR REPORT==== 20-Nov-2018::09:47:00 ===
Error in process <0.134.0> with exit value:
{badarith,[{skeletons2,fib,1,[{file,"skeletons2.erl"},{line,76}]},
           {skeletons2,worker,1,[{file,"skeletons2.erl"},{line,57}]}]}
Worker terminated
43> 
=ERROR REPORT==== 20-Nov-2018::09:47:00 ===
Error in process <0.135.0> with exit value:
{badarith,[{skeletons2,fib,1,[{file,"skeletons2.erl"},{line,76}]},
           {skeletons2,worker,1,[{file,"skeletons2.erl"},{line,57}]}]}
43> <0.130.0> ! {result, self()}.                                               {result,<0.69.0>}
44> flush().                                                                    Shell got [39088169,39088169,3524578,9227465,3524578,24157817,24157817,
           3524578,3524578,17711,5,3,2,9227465,3524578,3524578,3524578,
           3524578,17711,5,3,2,3524578,3524578,17711,5,3,2]
ok
45> i().                                                                        Pid                   Initial Call                          Heap     Reds Msgs
Registered            Current Function                     Stack              
<0.0.0>               otp_ring0:start/2                      376      845    0
init                  init:loop/1                              2              
<0.1.0>               erts_code_purger:start/0               233       18    0
erts_code_purger      erts_code_purger:wait_for_request        0              
<0.2.0>               erts_literal_area_collector:start      233        3    0
                      erts_literal_area_collector:msg_l        5              
<0.3.0>               erts_dirty_process_code_checker:s      233        3    0
                      erts_dirty_process_code_checker:m        1              
<0.6.0>               erlang:apply/2                        2586   905887    0
erl_prim_loader       erl_prim_loader:loop/3                   5              
<0.32.0>              gen_event:init_it/6                   2586    19548    0
error_logger          gen_event:fetch_msg/6                   10              
<0.33.0>              erlang:apply/2                        2586    13872    0
application_controlle gen_server:loop/7                        7              
<0.35.0>              application_master:init/4              233       69    0
                      application_master:main_loop/2           7              
<0.36.0>              application_master:start_it/4          233       90    0
                      application_master:loop_it/4             5              
<0.37.0>              supervisor:kernel/1                    610     2172    0
kernel_sup            gen_server:loop/7                       10              
<0.38.0>              erlang:apply/2                       75113   178287    0
code_server           code_server:loop/1                       3              
<0.40.0>              rpc:init/1                             233       32    0
rex                   gen_server:loop/7                       10              
<0.41.0>              global:init/1                          233       63    0
global_name_server    gen_server:loop/7                       10              
<0.42.0>              erlang:apply/2                         233       25    0
                      global:loop_the_locker/1                 5              
<0.43.0>              erlang:apply/2                         233        3    0
                      global:loop_the_registrar/0              2              
<0.44.0>              inet_db:init/1                         233      379    0
inet_db               gen_server:loop/7                       10              
<0.45.0>              global_group:init/1                    233       74    0
global_group          gen_server:loop/7                       10              
<0.46.0>              file_server:init/1                    1598     2250    0
file_server_2         gen_server:loop/7                       10              
<0.47.0>              gen_event:init_it/6                    233       51    0
erl_signal_server     gen_event:fetch_msg/6                   10              
<0.48.0>              supervisor_bridge:standard_error/      233       50    0
standard_error_sup    gen_server:loop/7                       10              
<0.49.0>              erlang:apply/2                         233       11    0
standard_error        standard_error:server_loop/1             2              
<0.50.0>              supervisor_bridge:user_sup/1           233       74    0
                      gen_server:loop/7                       10              
<0.51.0>              user_drv:server/2                      376   126448    0
user_drv              user_drv:server_loop/6                   9              
<0.52.0>              group:server/3                         376      349    0
user                  group:server_loop/3                      4              
<0.53.0>              group:server/3                       10958   415180    0
                      group:server_loop/3                      4              
<0.54.0>              kernel_config:init/1                   233       47    0
                      gen_server:loop/7                       10              
<0.55.0>              supervisor:kernel/1                    233      176    0
kernel_safe_sup       gen_server:loop/7                       10              
<0.59.0>              erlang:apply/2                        4185    20487    0
                      shell:shell_rep/4                       17              
<0.69.0>              erlang:apply/2                        4185   226960    0
                      c:pinfo/1                               50              
<0.89.0>              observer_wx:init/1                    6772    16486    0
observer              wx_object:loop/6                        10              
<0.90.0>              wxe_server:init/1                     1598     3139    0
                      gen_server:loop/7                       10              
<0.91.0>              wxe_master:init/1                     2586      893    0
wxe_master            gen_server:loop/7                       10              
<0.92.0>              erlang:apply/2                        1598   100973    0
                      timer:sleep/1                            5              
<0.94.0>              observer_sys_wx:init/1               10958    25875    0
                      wx_object:loop/6                        10              
<0.95.0>              timer:init/1                           610    25899    0
timer_server          gen_server:loop/7                       11              
<0.96.0>              observer_perf_wx:init/1                987     3595    0
                      wx_object:loop/6                        10              
<0.100.0>             observer_alloc_wx:init/1               376     4509    0
                      wx_object:loop/6                        10              
<0.101.0>             observer_app_wx:init/1                4185     9584    0
                      wx_object:loop/6                        10              
<0.102.0>             observer_pro_wx:init/1                 987     5257    0
                      wx_object:loop/6                        10              
<0.103.0>             erlang:apply/2                         987      842    0
                      observer_pro_wx:table_holder/1           8              
<0.105.0>             observer_port_wx:init/1                987     3383    0
                      wx_object:loop/6                        10              
<0.106.0>             observer_tv_wx:init/1                  376     3296    0
                      wx_object:loop/6                        10              
<0.107.0>             observer_trace_wx:init/1              2586    14144    0
                      wx_object:loop/6                        10              
<0.110.0>             appmon_info:init/1                    4185   901269    0
appmon_info           gen_server:loop/7                       10              
<0.130.0>             erlang:apply/2                         233       39    0
                      skeletons2:collector/1                   2              
<0.131.0>             erlang:apply/2                         233       90    4
                      skeletons2:dispatcher/1                  0              
<0.133.0>             erlang:apply/2                         233 18464485    0
                      skeletons2:worker/1                      4              
<0.136.0>             erlang:apply/2                         376      200    0
                      skeletons2:supervise/2                   5              
<0.157.0>             erlang:apply/2                         233 13350775    0
                      skeletons2:worker/1                      4              
<0.158.0>             erlang:apply/2                         233 15631360    0
                      skeletons2:worker/1                      4              
<0.159.0>             erlang:apply/2                         233 12479670    0
                      skeletons2:worker/1                      4              
Total                                                     151048 60229584    4
                                                             415              
ok
46> c(skeletons2)                                                               46> .          
skeletons2.erl:2: Warning: export_all flag enabled - all functions will be exported
{ok,skeletons2}
47> .                                                                           * 1: syntax error before: '.'
47> c(skeletons2).
skeletons2.erl:2: Warning: export_all flag enabled - all functions will be exported
{ok,skeletons2}
48> skeletons2:taskfarm(fun skeletons2:fib/1, [2,3,4]).                         <0.180.0>      
49> collector ! {result, self()}.
{result,<0.69.0>}
50> flush().                                           
Shell got [5,3,2]
ok
51> register(apple, self()).
true
52> apple ! hello.
hello
53> flush().                
Shell got hello
ok
54> <0.23456.0> ! message.
message
55> applhhhe ! hello.     
** exception error: bad argument
     in operator  !/2
        called as applhhhe ! hello
56> register(apple, self()).     
true
57> processes().
[<0.0.0>,<0.1.0>,<0.2.0>,<0.3.0>,<0.6.0>,<0.32.0>,<0.33.0>,
 <0.35.0>,<0.36.0>,<0.37.0>,<0.38.0>,<0.40.0>,<0.41.0>,
 <0.42.0>,<0.43.0>,<0.44.0>,<0.45.0>,<0.46.0>,<0.47.0>,
 <0.48.0>,<0.49.0>,<0.50.0>,<0.51.0>,<0.52.0>,<0.53.0>,
 <0.54.0>,<0.55.0>,<0.59.0>,<0.89.0>|...]
58> register(apple, <0.89.0>).
** exception error: bad argument
     in function  register/2
        called as register(apple,<0.89.0>)
59> register(apple, self()).  
true
60> register(applesss, self()).
** exception error: bad argument
     in function  register/2
        called as register(applesss,<0.192.0>)
61> register(apple, self()).   
true
62> 
62> register(apple, self()).
** exception error: bad argument
     in function  register/2
        called as register(apple,<0.195.0>)
63> register(apple, self()).
true
64> 

	
