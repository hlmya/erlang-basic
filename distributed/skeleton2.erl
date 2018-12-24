-module(skeleton2).
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