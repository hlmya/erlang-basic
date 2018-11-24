-module(ring).
-compile(export_all).

worker(PidNext) ->
	receive
		{forward,N} ->
			PidNext ! {forward,N+1},
			worker(PidNext);
		quit ->
			PidNext ! quit
	end.
	
start() ->
	Last = lists:foldl(fun(_,Pid) -> 
				spawn(ring, worker,[Pid])end,self(),lists:seq(1,5)),
	% lists:foldl starts 5 processes A→B→C→D→E and links P to A but not spawn P?
	% Last is Pid of E.
	% when T(1) -> PidE ! {forward,1} ???
	fun(X) -> 
		case X of
			quit -> 
				Last ! quit,
				receive
					quit -> quit
				end;
			_ -> 
				Last ! {forward,X},
				receive
					{forward,Result} -> Result
				end
		end
	end.