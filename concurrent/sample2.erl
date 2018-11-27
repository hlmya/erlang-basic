-module(sample2).
-compile(export_all).

% test:master(3,[1,2,3,4,54,3,1,2,6,77,8,0]).
% Sent: [1,2,3,4] to <0.62.0>   
% Sent: [54,3,1,2] to <0.63.0>   
% Sent: [6,77,8,0] to <0.64.0>   
% [0,1,1,2,2,3,3,4,6,8,54,77]
% master(integer(),list()) -> list()
% worker()-> true
% dispatcher(list(pid())),integer(),list(list()))-> true

split(L,N)->  Len= length(L)div N, split(L,Len,N).
split(L,_,1)-> [L];
split(L,Len,N)-> LN=lists:sublist(L,Len),[LN]++split(L--LN,Len,N-1).

master(N,L) ->
	MasterPid = self(),
	SplitLists = split(L,N),
	WorkerPids = lists:map(fun(_) -> spawn(fun() -> worker() end) end, lists:seq(1,N)),
	DispatcherPid = spawn(fun()-> dispatcher(MasterPid, length(L), []) end),
	sendandprintout(WorkerPids, SplitLists,DispatcherPid),
	receive
		{ok, DispatcherPid, Result} -> 
			end_work([DispatcherPid|WorkerPids]),
			Result
			
	end.

sendandprintout([],[],_) -> ok;
sendandprintout([Hpid|Tpid], [X|Y], DispatcherPid) ->
	Hpid ! {DispatcherPid, sort, X},
	io:format("Sent: ~p to ~p~n",[X, Hpid]),
	sendandprintout(Tpid,Y,DispatcherPid).

end_work(Pids) ->
	lists:foreach(fun(X) -> exit(X,kill) end, Pids),
	io:format("Work done~n",[]).

dispatcher(MasterPid, N, Acc)->
	receive
		{WorkerPid, Result} ->
			case length(Result) == N of
				true -> 
					MasterPid ! {ok, self(), Result},
					io:format("Sent final result to Master~n");
				false ->
					UpdatedResult = [Result | Acc],
					io:format("UpdatedResult: ~p~n",[UpdatedResult]),
					case length(UpdatedResult)  >= 2 of
						true -> 
							WorkerPid ! {self(), merge, UpdatedResult},
							dispatcher(MasterPid, N, UpdatedResult);
						false -> dispatcher(MasterPid, N, UpdatedResult)
					end
			end
	end.

% receive F and List and then return the result after apply Function
worker()->
	receive
		{PidD, sort, List} -> 
			PidD ! {self(),lists:sort(List)},
			io:format("Sorted list ~p~n",[lists:sort(List)]),
			worker();
		{PidD, merge, List} -> 
			PidD ! {self(),lists:merge(List)},
			io:format("Sorted list ~p~n",[lists:merge(List)]),
			worker()
	end.
% Model:
% master -> 
% 1. spawn workers and send request sort to worker
% 2. spawn dispatcher
% 3. receive final result from dispatcher

% worker ->
% 1. receive and request sort or merge, then send result to dispatcher

% dispatcher ->
% 1. receive sorted or merged lists from workers and handling them
% 2. send the final result to master

% test master
% 3> sample2:master(3,[1,2,3,4,54,3,1,2,6,77,8,0]).
% Sent: [1,2,3,4] to <0.82.0>
% Sorted list [1,2,3,4]
% UpdatedResult: [[1,2,3,4]]
% Sent: [54,3,1,2] to <0.83.0>
% Sorted list [1,2,3,54]
% UpdatedResult: [[1,2,3,54],[1,2,3,4]]
% Sent: [6,77,8,0] to <0.84.0>
% Sorted list [0,6,8,77]
% Sorted list [1,1,2,2,3,3,4,54]
% ... compiler stops here
% => 2 worker processes (Sorted list [0,6,8,77]) and (Sorted list [1,1,2,2,3,3,4,54]) try to send msg at a same time to the dispatcher
% => cause conflicts, I think
% => How to solve it?

