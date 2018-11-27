-module(nngd).

%% Server interface
-export([start/0, stop/0]).

%% Client
-export([next/0]).

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
	
next() -> 
	{nng_server, 'srv@157.181.163.42'} ! {next, self(), R = make_ref()},
	receive
		{number, Num, R} ->
			Num
	end.
	
%next(Node) ->
%	{nng_server, Node} ->
	
	%receive
		%stop ->
			%io:format("Server terminated~n");
		%{next, Pid} ->
			%Num = State,
			%Pid ! Num,
			%NewState = Num +1,
			%loop(NewState)
	%end.
