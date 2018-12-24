-module(chat1).
-compile(export_all).

%server
start() ->
	register(srvpid, spawn(fun()-> loop(#{}) end)).

stop() ->
	srvpid ! stop.

loop(UserMap) ->
	io:format("List of User: ~p~n",[UserMap]),
	receive
		stop -> 
			io:format("Server terminates!");
		{login, UserPid, UserName} ->
			case UserMap of
				#{UserPid:=UserName} ->
					io:format("Login:Unhappy~n"),
					UserPid ! unhappy,
					loop(UserMap);
				_ ->
					io:format("Login:Happy~n"),
					UserPid ! happy,
					loop(UserMap#{UserPid=>UserName})
			end
	end.

%client
login(UserName, Nodesrv) ->
	{srvpid, Nodesrv} ! {login, self(), UserName},
	receive
		happy -> io:format("Login successfully!~n");
		unhappy -> io:format("Login UNsuccessfully!~n")
	end.

send(Msg, Nodesrv) -> ok.