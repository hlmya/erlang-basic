-module(pr1).
-compile(export_all).
% http://erlang.org/doc/getting_started/users_guide.html
say_something(What, 0) ->
    done;
say_something(What, Times) ->
    io:format("~p~n", [What]),
    say_something(What, Times - 1).
% two Erlang processes
% start() ->
    % spawn(pr1, say_something, [hello, 3]),
    % spawn(pr1, say_something, [goodbye, 3]).
	
% <0.63.0> come from? 
% The return value of a function is the return value of the last "thing" in the function.
% <0.63.0> is the pid of the spawn function

ping(0, Pong_PID) ->
    Pong_PID ! finished,
    io:format("ping finished~n", []);

ping(N, Pong_PID) ->
    Pong_PID ! {ping, self()},
    receive
        pong ->
            io:format("Ping received pong~n", [])
    end,
    ping(N - 1, Pong_PID).

pong() ->
    receive
        finished ->
            io:format("Pong finished~n", []);
        {ping, Ping_PID} ->
            io:format("Pong received ping~n", []),
            Ping_PID ! pong,
            pong()
    end.

start() ->
    Pong_PID = spawn(pr1, pong, []),
    spawn(pr1, ping, [3, Pong_PID]).
%==============
dolphin1() ->
receive
do_a_flip ->
io:format("How about no?~n");
fish ->
io:format("So long and thanks for all the fish!~n");
_ ->
io:format("Heh, we're smarter than you humans.~n")
end.

dolphin3() ->
	receive
		{From, do_a_flip} ->
		From ! "How about no?",
		dolphin3();
		{From, fish} ->
		From ! "So long and thanks for all the fish!";
		_ ->
		io:format("Heh, we're smarter than you humans.~n"),
		dolphin3()
	end.
% Q: flush?
%https://learnyousomeerlang.com/the-hitchhikers-guide-to-concurrency#dont-panic
%=============== seventh.erl
run1(N) ->
	lists:foreach(fun(_) -> spawn(fun task/0) end, lists:seq(1, N)).
	
task() ->
	io:format("MyPid: ~p~n", [self()]).

fib(0) ->
	1;
fib(1) ->
	1;
fib(N) ->
	fib(N-1) + fib(N-2).
	
call(List) ->
	lists:map(fun fib/1, List).
	
%=============== skeletons.erl
run(N) ->
	MyPid = self(),
	Last = lists:foldl(fun(_, PrevPid) -> 
							spawn(fun() -> task(PrevPid) end)
					   end, MyPid, lists:seq(1, N)),
	Last ! ok,
	receive
		ok -> "end of the ring"
	end.

task(Prev) ->
	receive
		ok -> Prev ! ok
	end.

% Q: Last!ok -> Last is a list of Pid????, how to send message?

%Q:Why running time are different when re-run many times?
% 10> timer:tc(pr1,run,[1000]).
% {14999,"end of the ring"}
% 21> timer:tc(pr1,run,[1000]).
% {0,"end of the ring"}
% 22> timer:tc(pr1,run,[1000]).
% {15999,"end of the ring"}
% 23> timer:tc(pr1,run,[1000]).
% {0,"end of the ring"}

% Q: if there are 2 processes send message to one process, 
% the value in the process received is updated or not?
	
taskfarm(F, List) ->
	K = erlang:system_info(logical_processors),
	Collector = spawn(fun() -> collector([]) end),
	Dispatcher = spawn(fun() -> dispatcher(List) end),
	lists:foreach(fun(_) -> 
					spawn(fun() -> worker({Collector, Dispatcher, F}) end) 
				  end, lists:seq(1, K)).

dispatcher([]) ->
	receive
		{restart, NewList} ->
			dispatcher(NewList)
	end;
dispatcher([Data|Tail]) ->
	receive
		{ready, Worker} ->
			Worker ! Data,
			dispatcher(Tail)
	end.

collector(Acc) ->
	receive
		{result, Pid} ->
			Pid ! Acc,
			collector(Acc);
		Result -> 
			collector([Result|Acc])
	end.

worker({Collector, Dispatcher, F} = Args) ->
	Dispatcher ! {ready, self()},
	receive
		Data ->  
			Collector ! F(Data),
			worker(Args)
	end.
	
	
%========== youtube
loop() ->
	receive
		{From,Msg} ->
			From ! {self(),Msg},
			loop();
		stop ->
			true
	end.
	
go() -> 
	Pid = spawn(pr1,loop,[]),
	Pid ! {self(), kaka},
	receive
		{PidLoop, Msg} -> 
			io:format("~w~n",[Msg])
	end,
	PidLoop ! stop.
%===========
main(T) ->
	receive
		{Pid, stop} -> Pid ! stopped;
		{Pid, N} ->
			Next = N + T,
			Pid ! Next,
			main(Next)
	end.

start1() -> spawn(pr1,main,[0]).
%=================
a() ->
	% PidB = spawn(fun() -> b() end),
	PidB = spawn(pr1, b, []),
	PidB ! {self(), atoma},
	receive
		{PidBB, Msg} -> io:format("A() received ~p~n",[Msg])
	end.
	
b() ->
	receive
		{PidAA, Msg} -> 
			io:format("B received ~p~n",[Msg]),
			PidAA ! {self(), Msg}
	end.
%===============

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
