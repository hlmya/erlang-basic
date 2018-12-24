-module(client).
-export([start/1]).

start(Nick) when is_list(Nick)->
	case chat:login(Nick) of
		ok ->
			CPid = self(),
			spawn(fun() -> io(CPid) end),
			cloop();
		deny -> 
			"Nick name already used";
		timeout ->
			"No connection to the server"
	end;
start(_N) ->
	"The Nick name has to be a string".

io(C) ->
	case string:strip(io:get_line(">> "), right, $\n) of %% lists:droplast
		"#quit" -> 
			C ! stop;
		Msg -> 
			C ! {text, Msg} , 
			io(C)
	end.

cloop() ->
	receive
		stop -> 
			chat:logout(),
			"Client terminated";
		{text, Msg} ->
			chat:send(Msg),
			cloop();
		{msg, Text} ->
			io:format("~p~n", [Text]),
			cloop()
	end.
	
%string:strip("adf",right,$f). => drop character