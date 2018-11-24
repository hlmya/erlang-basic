-module(ring).
-compile(export_all).

worker(PidNext) ->
	receive
		{forward,N} ->
			PidNext ! (N+1),
			worker(PidNext);
		quit ->
			PidNext ! quit
	end.
	
start() ->
	MyPid = self(),
	WorkerPid = spawn(fun() -> worker(MyPid) end),
	fun(X) -> 
		case X of
			quit -> 
				WorkerPid ! quit,
				receive
					quit -> quit
				end;
			_ -> 
				WorkerPid ! {forward,X},
				receive
					Result -> Result
				end
		end
	end.