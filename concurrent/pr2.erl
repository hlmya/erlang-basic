-module(pr2).
-compile(export_all).
% ======== No.1
%Ping-pong process. Ping send msg to Pong and receive msg from Pong 
%and Pong receives and send back to pong, 3 times. ping stop
% 2> tut15: start().
% <0.36.0>
% Pong received ping
% Ping received pong
% Pong received ping
% Ping received pong
% Pong received ping
% Ping received pong
% ping finished
% Pong finished

ping(0, Pidpong) ->
	Pidpong ! finish,
	io:format("ping finished~n",[]);
	
ping(N, Pidpong) ->
	Pidpong ! {ping, self()},
	receive
		pong ->
			io:format("Ping received ~p~n",[pong]),
			ping(N-1,Pidpong)
	end.

pong() -> 
	receive
		{ping,Pidping} ->
			io:format("Pong received ~p~n",[ping]),
			Pidping ! pong,
			pong();
		finish ->
			io:format("pong finished~n",[])
	end.
	
start_pingpong()->
	Pidpong = spawn(fun() -> pong() end),
	spawn(fun() -> ping(3,Pidpong) end).

% ========= No.2
% Print out Pid with N times. foreach, run/1, task/0
% spawn(fun task/0)
run(N) ->
	% lists:foreach(fun(_X) -> spawn(fun() -> io:format("My pid ~p~n",[self()])  end) end, lists:seq(1,N)).
	lists:foreach(fun(_X) -> spawn(fun() -> task() end) end, lists:seq(1,N)).

task() ->
	io:format("My pid ~p~n",[self()]).

% ========= No.3
% Call fib with concurrency with order by Map and Normal
fib(0) -> 1;
fib(1) -> 1;
fib(N) ->
	fib(N-1) + fib(N-2).
	
call_par_order(List) -> 
	Pid = self(),
	lists:map(fun(X) -> spawn(fun() -> Pid ! {X,fib(X)} end) end, List),
	lists:map(fun(X) -> receive
							{X, Result} -> Result
						end
			  end, List).
call_par_map(List) ->
	MyPid = self(),
	Pids = lists:map(fun(X) -> spawn(fun() -> MyPid ! {self(),fib(X)} end) end, List),
	lists:map(fun(Pid) -> receive
							{Pid, Result} -> Result
						  end
			  end, Pids).

% ========= No.4
% Create a skeleton process:
% -taskfarm(FIB fun, List): initialize and printout result list of fib
% -dispatcher(List): like a loop, send each element in a list to worker if {ready, PidWorker} 
% when List is not empty and restart if {restart,NewList} when list is empty.
% -collector(List): receive {result,pid} -> send Acc, if recieve data -> add to acc
% -worker(3):+ send to dispatcher if {ready, pid}, receive data -> cal 
% and then send to collect, and reloop to wait for next receive
% Example:
% skeletons:taskfarm(fun skeletons:fib/1, [1,2,3,4,5,6]).
% ok

taskfarm(F,List) ->
	K = erlang:system_info(logical_processors),
	Collector_Pid = spawn(fun() -> collector([]) end),
	Dispatcher_Pid = spawn(fun() -> dispatcher(List) end),
	lists:foreach(fun(_X) -> spawn(pr2, worker,[Dispatcher_Pid, Collector_Pid, F]) end, lists:seq(1,K)),
	timer:sleep(1),
	Collector_Pid ! {result,self()},
	receive
		Acc -> Acc
	end.
		
dispatcher([]) ->
	receive
		{restart, NewList} ->
			dispatcher(NewList)
	end;
dispatcher([H|T]) ->
	receive
		{ready,WorkerPid} ->
			WorkerPid ! H,
			dispatcher(T)
	end.

% collect the result
collector(Acc) ->
	receive
		{result, Pid} -> % any request and ask for result
			Pid ! Acc,
			collector(Acc);
		Result -> 
			collector(Acc ++ [Result])
	end.
	
worker(Dispatcher_Pid, Collector_Pid, F) ->
	Dispatcher_Pid ! {ready,self()},
	receive
		Data -> 
			Collector_Pid ! F(Data),
			worker(Dispatcher_Pid, Collector_Pid, F)
	end.
			
		
% ============ No.5
% Print "end of the ring" when get the last Pid with run(N) and task(pidPrev)

