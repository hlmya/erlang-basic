-module(sampletest).
-compile(export_all).

mapReduce(M, Text) ->
	MapReducePid = self(),
	ReducePid = spawn(fun() -> reduce(MapReducePid,#{})end),
	Last = lists:foldl(fun() -> spawn(fun() -> mapReduce(ReducePid))end,MapReducePid, lists:seq(1,M))
	Lines = string:tokens(Text, "\n"),
	lists:map(fun(Line) -> Last ! Line end, Lines),
	...
	
map(ReducePid) ->
	receive
		Line ->
			Words = string:tokens(Line," "),
			lists:map(fun(Word) -> ReducePid ! {Word,1} end, Words)
	end.
	
reduce(MapReducePid,CurrentResult) ->
	receive
		{Word,1} ->
			case CurrentResult of
				#{Word := Val} -> CurrentResult#{Word => Val + 1};
				_ -> CurrentResult#{Word => 1}
			end
	after
		20 ->
			io:format("I am done!~n",[]),
			MapReducePid ! CurrentResult
	end.
			
			
	