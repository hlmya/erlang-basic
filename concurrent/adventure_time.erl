-module(adventure_time).
-compile(export_all).

finn(PidJake)->
	io:format("Finn: What time is it?~n",[]),
	PidJake ! {what_time_is_it, self()},
	receive
		adventure_time ->
			io:format("Finn: That's right buddy~n",[])	
	end.

jake() ->
	receive
		{what_time_is_it, PidFinn} -> 
			io:format("Jake: Adventure time!~n",[]),
			PidFinn ! adventure_time
	end.

% begin_adventure() ->
	% PidJake = spawn(fun() -> jake() end),
	% spawn(fun() -> finn(PidJake) end).
	
begin_adventure() ->
	PidJake = spawn(adventure_time,jake,[]),
	spawn(adventure_time,finn, [PidJake]).