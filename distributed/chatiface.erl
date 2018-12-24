-module(chatiface).

%% Client interface
-export([login/1, send/1, logout/0]).

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