-module(client_redo).
-export([start/1]).

start(Nick) when is_list(Nick) ->
	case chat_redo:login(Nick) of
		ok ->
			CPid = self(),
			spawn(fun()->io(CPid) end),
			loop();
		deny ->
			"Nick is already used";
		timeout -> 
			"No connection to server"
	end;
start(_) -> "Nick has to be a string".

io(CPid) ->
	case string:strip(io:get_line(">> "),right,$\n) of
		"#quit" ->
			CPid ! stop;
		Msg ->
			CPid ! {text, Msg},
			io(CPid)
	end.

loop() ->
	receive
		stop -> 
			chat_redo:logout(),
			"Client terminate";
		{text, Msg} ->
			chat_redo:send(Msg),
			loop();
		{msg, RepliedMsg} ->
			io:format("~p~n",[RepliedMsg]),
			loop()
	end.



