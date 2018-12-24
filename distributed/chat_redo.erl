-module(chat_redo).

%Client interface
-export([login/1,logout/0,send/1]).
% Server interface
-export([start/1, stop/0]).

% Client interface

login(UserName) when is_list(UserName) ->
	global:send(chat_redo,{login,self(),UserName}),
	receive
		loginedin -> ok;
		nick_used -> deny
	after
		5000 -> timeout
	end.

logout() ->
	global:send(chat_redo,{logout,self()}).

send(Msg) ->
	global:send(chat_redo,{send,self(),Msg}).


% Server implementation
start(Max) ->
	global:register_name(chat_redo, spawn(fun()-> init(Max) end)).

stop() ->
	global:send(chat_redo,stop).

init(Max) ->
	process_flag(trap_exit,true),
	UserMap = [],
	loop(UserMap,Max).

loop(UserMap,Max) ->
	receive
		stop ->
			io:format("Server terminated!! ~n");
		{'EXIT', CPid, _Reason} ->
			io:format("User die: ~p~n",[CPid]),
			UpdateUserMap = lists:keydelete(CPid,1,UserMap),
			loop(UpdateUserMap, Max);
		state ->
			io:format("state of user: ~p~n",[UserMap]);
			
		{login, CPid, UserName} ->
			case lists:keyfind(UserName,2,UserMap) of
				false ->
					link(CPid),
					UpdateUserMap = UserMap ++ [{CPid,UserName}],
					CPid ! loginedin,
					loop(UpdateUserMap,Max);
				_ ->
					CPid ! nick_used,
					loop(UserMap,Max)
			end;
		{logout, CPid} ->
			UpdateUserMap = lists:keydelete(CPid,1,UserMap),
			loop(UpdateUserMap,Max);
		{send, CPid, Msg} ->
			case lists:keyfind(CPid,1,UserMap) of 
				false -> unauthorized;
				{Pid,UserName} ->
					NewMessage = UserName ++ ":" ++ Msg,
					Pid ! {msg, NewMessage},
					loop(UserMap,Max)
			end
	end.
	



