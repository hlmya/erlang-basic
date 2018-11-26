-module(extra).
-compile([export_all]).
%extra 1
mapReduce(M,R, Text) ->
	MapReducePid = self(),
	ReducePids = lists:map(fun(_) -> spawn(fun() -> reduce(MapReducePid,[]) end) end, lists:seq(1,R)),
	MapPids = lists:map(fun(_) -> spawn(fun() -> map(ReducePids) end) end, lists:seq(1,M)),
	Lines = string:tokens(Text, "\n"),
	send(MapPids, Lines),
	receive
		{ok, Result} -> 
			killAll(ReducePids ++ MapPids),
			Result
	end.
	
send(MapPids, Lines) ->
	lists:foreach( fun(Line) -> (lists:nth(rand:uniform(length(MapPids)), MapPids)) ! Line end, Lines).

killAll(Pids) ->
	lists:foreach(fun(X) -> exit(X,kill) end, Pids),
	io:format("Killed ~p~n",[Pids]).

map(ReducePids) ->
	receive
		Line ->
			Words = string:tokens(Line, " "),
			lists:foreach(fun(W) -> (lists:nth(rand:uniform(length(ReducePids),ReducePids))) ! {W,1} end, Words),
			map(ReducePids)
	end.


reduce(MapReducePid,CurrentResult) ->
	receive
		{Word,1} ->
			NewList = case lists:keyfind(Word, 1, CurrentResult) of
						false ->
							[{Word,1}|CurrentResult];
						{Word,N} ->
							lists:keyreplace(Word,1,CurrentResult,{Word, N+1})
						end,
			reduce(MapReducePid,NewList)
	after
		2000 ->
			io:format("I'm done~n",[]),
			MapReducePid ! {ok, CurrentResult}
	end.
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	