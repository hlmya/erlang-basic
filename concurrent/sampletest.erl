-module(sampletest).
-compile(export_all).
			
mapReduce(M,Text)->
	MapReducePid = self(),
	RedPid = spawn(?MODULE,reduce, [MapReducePid,[]]),
	MapPids = lists:map(fun(_)->spawn(fun()->map(RedPid)end)end,lists:seq(1,M)),
	L = string:tokens(Text,"\n"),
	send(MapPids,L),
	receive
		{ok,RedPid,Result} -> 
			killAll([RedPid|MapPids]),
			Result
	end.

send(_,[]) -> ok;
send(MP,[LH|LT])->
	Pid = lists:nth(rand:uniform(length(MP)),MP),
	Pid ! {map, LH},
	send(MP,LT).

map(RPid) ->
	receive
		{map,L} -> 
			Words = string:tokens(L," "),
			lists:foreach(fun(W) -> RPid ! {W,1} end, Words),
			map(RPid) % starting again because need to get random
	end.

reduce(MapReducePid,CResult) ->
	receive
		{W,1} ->
			Exist = lists:keyfind(W,1,CResult),
			NewRes = case Exist of
						false -> [{W,1}|CResult];
						{W,N} -> lists:keyreplace(W,1,CResult,{W,N+1})
					 end,
			reduce(MapReducePid,NewRes)
	after 2000 -> 
		io:format("I'm done~n",[]),
		MapReducePid ! {ok,self(),CResult}
	end.

killAll(Pids) ->
	lists:foreach(fun(ProcessId) -> exit(ProcessId,kill) end, Pids),
	io:format("Killed ~p~n",[Pids]).
	

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	