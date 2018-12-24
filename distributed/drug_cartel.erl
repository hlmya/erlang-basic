-module(drug_cartel).
-export([warehouse/0]).
	% spawn(fun() -> bad_guy("kid") end),
	% spawn(fun() -> bad_guy("kids") end),
warehouse() ->
	register(guard, spawn(fun()-> guard([],"kids") end)),
	lists:foreach(fun(_) -> spawn(fun() -> bad_guy("kids") end) end,lists:seq(1,3)),
	lists:foreach(fun(_) -> spawn(fun() -> bad_guy("kid") end) end,lists:seq(1,4)),
	timer:sleep(1000),
	spawn(fun() -> fbi() end).
	
guard(TraffickerPids, Passw) ->
	receive
		{let_in, Who} ->
			Who ! whats_the_password,
			guard(TraffickerPids, Passw);
		{password, Password, Who} ->
			case Password == Passw of
				true ->
					UpdateList = [Who] ++ TraffickerPids,
					Who ! come_in,
					guard(UpdateList,Passw);
				false ->
					Who ! go_away,
					guard(TraffickerPids,Passw)
			end;
		im_a_cop ->
			io:format("Guard:Cops are here!~n"),
			lists:foreach(fun(Pid)-> Pid ! cops_are_here end, TraffickerPids)
	end.
% if bad_guy is not in the list -> no one inside 
bad_guy(Password) ->
	Bad_guy_pid = self(),
	guard ! {let_in, Bad_guy_pid},
	receive
		whats_the_password ->
			guard ! {password, Password, Bad_guy_pid},
			bad_guy(Password);
		come_in ->
			io:format("~p: Guard allows to come in!~n",[self()]),
			receive
				cops_are_here ->
					io:format("~p: I'm outta here!~n",[self()])
			end;
		go_away ->
			io:format("~p: Guard didn't let me in. ~n",[self()])
	end.

fbi() ->
	guard ! {let_in, self()},
	receive
		whats_the_password ->
			guard ! im_a_cop
	end.
