-module(skeletons).
-compile(export_all).

taskfarm(F, List) ->
	K = erlang:system_info(logical_processors), % number of process computer provides
	Collector = spawn(fun() -> collector([]) end),
	Dispatcher = spawn(fun() -> dispatcher(List) end),
	lists:foreach(fun(_) -> 
					spawn(fun() -> worker({Collector, Dispatcher, F}) end) 
				  end, lists:seq(1, K)),
	timer:sleep(5000),
	Collector ! {result, self()},
	receive
		Result -> Result
	end.
	
% get_result(CollectorPid) ->
	% CollectorPid ! {result, self()},
	% receive
		% [] -> get_result(CollectorPid);
		% Result -> Result
	% end.

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

% run(N) ->
	% MyPid = self(),
	% Last = lists:foldl(fun(_, PrevPid) -> 
							% spawn(fun() -> task(PrevPid) end)
					   % end, MyPid, lists:seq(1, N)),
	% Last ! ok,
	% receive
		% ok -> "end of the ring"
	% end.
	
% task(Prev) ->
	% receive
		% ok -> Prev ! ok
	% end.
	
fib(0) ->
	1;
fib(1) ->
	1;
fib(N) ->
	fib(N-1) + fib(N-2).