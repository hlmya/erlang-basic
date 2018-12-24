-module(chat).

%% Client interface -> this part is hiding from client
-export([login/1, send/1, logout/0]).

%% Server interface
-export([start/1, stop/0, loop/1]).

% client interface =============================
login(Nick) when is_list(Nick) ->
	global:send(chat, {login, self(), Nick}),
	receive
		loggedin -> ok;
		nick_used -> deny
	after
		5000 -> timeout
	end.

send(Msg) ->
	global:send(chat, {send, self(), Msg}).

logout() ->
	global:send(chat, {logout, self()}).

% ================================

%% Server interface

start(Max) ->
	global:register_name(chat, spawn(fun() -> init(Max) end)).

stop() ->
	global:send(chat, stop).
	
init(Max) ->
	process_flag(trap_exit, true),
	Users = #{},
	State = {Users, Max},
	chat:loop(State).
	
loop(State={Users, Max}) ->
	receive
		stop ->
			io:format("Server termonated~n");
		dump ->
			io:format("~p~n", [Users]),
			chat:loop(State);
		{'EXIT', Pid, _Reason} ->
			io:format("User die !!!!!!!!!"),
			loop({maps:remove(Pid, Users), Max});
			
		{logout, Pid} ->
			loop({maps:remove(Pid, Users), Max});
		{login, Pid, Nick} ->
			case lists:member(Nick, maps:values(Users)) of
				false -> 
					Pid ! loggedin,
					link(Pid),
					NewUsers = Users#{Pid => Nick},
					loop({NewUsers, Max});
				true ->
					Pid ! nick_used,
					loop(State)
			end;
		{send, Pid, Msg} ->
			case Users of
				#{Pid:=Nick} -> 
					NewMsg = Nick ++ ": " ++ Msg,
					maps:fold(fun(K, _, _) ->
								K ! {msg, NewMsg}, K ! {msg, NewMsg}
							  end, ok, Users);
				_ ->
					io:format("Unauthorised sender~p~n", [Pid])
			end,
			loop(State)
	end.