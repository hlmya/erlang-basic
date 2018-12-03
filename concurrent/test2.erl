-module(test2).
-compile(export_all).

% No.1
pfilter(Pred, List) ->
	MyPid = self(),
	lists:map(fun(X) -> spawn(fun() -> MyPid ! {self(),X,Pred(X)} end) end, List),
	GC = spawn(fun() -> garbagecollector([]) end),
	pfilter(Pred, List, [], GC).
	
pfilter(_, [], Acc, _) ->  Acc;
pfilter(Pred, [_H|T], Acc, GC) ->
	receive
		{_Pid, X, Check} ->
			case Check of
				true -> pfilter(Pred, T, Acc ++ [X], GC);
				false -> 
					GC ! {false, X},
					pfilter(Pred, T, Acc, GC)
			end
	end.

% No.4
garbagecollector(Acc) ->
	receive
		{false, X} ->
			Collect = [X|Acc],
			io:format("Garbage collector ~p~n", [Collect]),
			garbagecollector(Collect)
	end.

% No.2
pcomposition(Funs, Values) -> 
	MyPid = self(),
	Last = lists:foldl(fun(_, NextPid) -> spawn(?MODULE, pcomposition_single, [NextPid]) end, MyPid, lists:seq(1, length(Funs))),
	lists:map(fun(X) -> Last ! {forward, X, Funs} end, Values),
	lists:map(fun(_) -> 
					receive
						{forward, Val, []} -> 
							io:format("Final result ~p~n",[Val]),
							Val	
					end
			  end,Values).
	
pcomposition_single(NextPid) ->
	receive
		{forward, Val, [F|Rest]} ->
			NextPid ! {forward, F(Val), Rest},
			io:format("F(Val): ~p~n", [F(Val)]),
			pcomposition_single(NextPid)
	end.