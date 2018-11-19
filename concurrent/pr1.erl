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
% run(N) ->
	% lists:foreach(fun(_) -> spawn(fun task/0) end, lists:seq(1, N)).
	
% task() ->
	% io:format("MyPid: ~p~n", [self()]).
	% 0.

fib(0) ->
	1;
fib(1) ->
	1;
fib(N) ->
	fib(N-1) + fib(N-2).
	
call(List) ->
	lists:map(fun fib/1, List).
	
call_par(List) ->
	MyPid = self(),
	lists:map(fun(X) -> spawn(fun() -> MyPid ! pr1:fib(X) end) end, List),
	lists:map(fun(_X) -> receive
							A -> A
						 end
			  end, List).
%Q: call_par -> MyPid is PID of SHELL or Pid of call_par? call_par is not current process
%Q: lists:map(fun(X) -> spawn(fun() -> MyPid ! pr1:fib(X) end) end, List) => list of PID
%Q: lists:map(fun(_X) -> receive... -> collect result => list of PID include results?
%Q: Value type that "receive" accepts?
			
call_par_ord(List) ->
	MyPid = self(),
	lists:map(fun(X) -> spawn(fun() -> MyPid ! {X, pr1:fib(X)} end) end, List),
	lists:map(fun(X) -> receive
							{X, A}  -> A
						 end
				end, List).

par_map_ord(F, List) ->
	MyPid = self(),
	Pids = lists:map(fun(X) -> spawn(fun() -> MyPid ! {self(), F(X)} end) end, List),
	lists:map(fun(Pid) -> receive
							{Pid, A}  -> A
						 end
				end, Pids).
% Q: par_map_ord get a pair {self(),F(X)} instead of {X,F(X)}. Cannot use X? 
% Q: call_par_ord and par_map_ord are the same in general?



	%receive
		%1 -> 1;
		%Apple when is_atom(Apple)-> atom;
		%Value -> Value
	%end.
	
	
% lists:map(fun(X) -> spawn(fun() -> MyPid ! {self(), F(X)} end) end, List)
% lists:map(fun(X) -> spawn(fun() -> self() ! {X, pr1:fib(X)} end) end, [31,23,36,23,35])

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
	
	
	
	