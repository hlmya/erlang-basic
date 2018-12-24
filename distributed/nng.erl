-module(nng).

% Server interface
% -export([start/0, stop/0]).

% Client
% -export([next/1]).
-compile(export_all).
start() ->
	register(nng_server, spawn(fun() -> loop(0) end)).
	
stop() ->
	nng_server ! stop.
	
loop(Num) ->
	receive
		stop ->
			io:format("Server terminated~n");
		{next, Pid, R} ->
			Pid ! {number, Num, R},
			loop(Num +1)
	end.
	
next(NodeSrv) ->
	% {nng_server,'svr@192.168.1.72'} ! {next, self(), R = make_ref()},
	% {nng_server,'server@DESKTOP-G8898U4'} ! {next, self(), R = make_ref()},
	{nng_server, NodeSrv} ! {next, self(), R = make_ref()},
	receive
		{number, Num, R} ->
			Num
	end.
	
	%receive
		%stop ->
			%io:format("Server terminated~n");
		%{next, Pid} ->
			%Num = State,
			%Pid ! Num,
			%NewState = Num +1,
			%loop(NewState)
	%end.