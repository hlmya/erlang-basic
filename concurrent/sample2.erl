-module(sample2).
-compile([export_all]).

% sample2:master(3,[1,2,3,4,54,3,1,2,6,77,8,0]).
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
	MasterPid = whereis(master),
	case MasterPid of
		undefined -> ok;
		_ -> unregister(master)
	end,
	register(master,self()),
	
	process_flag(trap_exit, true),
	
	SplitLists = split(L,N),
	WorkerPids = lists:map(fun(_) -> spawn_link(fun() -> worker() end) end, lists:seq(1,N)),
	DispatcherPid = spawn_link(fun()-> dispatcher(WorkerPids, length(L), []) end),
	sendandprintout(WorkerPids, SplitLists,DispatcherPid),
	receive
		{ok, DispatcherPid, Result} ->
			end_work([DispatcherPid|WorkerPids]),
			Result	
	end.

sendandprintout([],[],_) -> ok;
sendandprintout([Hpid|Tpid], [X|Y], DispatcherPid) ->
	Hpid ! {DispatcherPid, fun lists:sort/1, X},
	io:format("Sent: ~p to ~p~n",[X, Hpid]),
	sendandprintout(Tpid,Y,DispatcherPid).

end_work(Pids) ->
	lists:foreach(fun(X) -> exit(X,kill) end, Pids),
	io:format("Work done ~p ~n",[Pids]).

dispatcher(WorkerPids, N, Acc)->
	MasterPid = whereis(master),
	receive
		{'EXIT', PidW, "unused"} ->
				PidWorker = spawn_link(?MODULE, worker, []),
				io:format("Start: ~p~n",[PidW]),
				dispatcher([PidW|WorkerPids], N, Acc);
		{WorkerPid, Result} ->
			case length(Result) == N of
				true -> 
					MasterPid ! {ok, self(), Result},
					io:format("Sent final result to Master~n");
				false ->
					UpdatedResult = [Result | Acc], % Acc should be Acc or 1 element
					io:format("UpdatedResult: ~p~n",[UpdatedResult]),
					case length(UpdatedResult)  == 2 of
						true -> 
							WorkerPid ! {self(), fun lists:merge/1, UpdatedResult},
							dispatcher(MasterPid, N, []); % reset Acc is important
						false -> dispatcher(MasterPid, N, UpdatedResult)
					end
			end
		
	end.

% receive F and List and then return the result after apply Function
worker()->
	receive
		{PidD, F, List} -> 
			AppliedF = apply(F,[List]),
			PidD ! {self(),AppliedF},
			io:format("Sorted list ~p~n", [AppliedF]),
			worker()
	after
		10000 ->
			io:format("Suicide ~p~n",[self()]), 
			exit(self(),"unused")
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

% dispatcher(MasterPid, N, Acc)->
	% receive
		% {WorkerPid, Result} ->
			% case length(Result) == N of
				% true -> 
					% MasterPid ! {ok, self(), Result},
					% io:format("Sent final result to Master~n");
				% false ->
					% UpdatedResult = [Result | Acc],
					% io:format("UpdatedResult: ~p~n",[UpdatedResult]),
					% case length(UpdatedResult)  >= 2 of
						% true -> 
							% WorkerPid ! {self(), fun lists:merge/1, UpdatedResult},
							% dispatcher(MasterPid, N, UpdatedResult);
						% false -> dispatcher(MasterPid, N, UpdatedResult)
					% end
			% end
	% end.