-module(msor).
-compile([export_all]).

%SOLUTION to the first 3 points:

%1)Implement a Parallel merge sort in Erlang using a master process and a pool of workers :   master/2 divide a list L in N parts and spawns N workers each with the order to sort a part of the list. Print on the console the sent lists and the process that is handling them. Than it waits for the answer. After the master receive the result it kills all the workers.

%Worker/0 is a generic function that receive a  message containing a Pid(the distpatcher one) a Function and a List to apply the function to. It return the result to Pid and restart itself. 

%Define/3 a distpacher that collects the sorted lists from the worker and send them back to be merged. The distpacher takes a list of workers processes Id, the length of the original list to sort and a Result variable keeping track of the sorted lists. Every time a worker send a sorted list,the dispatcer checks if it has at least two sorted lists available and send 2 of them to the worker to merge them. Merged lists must be saved also in to the pool of lists needing merging (Results) until there is just one list in the pool whose size is the lenght of the original list. At this point you're done: the distpacher send the result to the master that makes the  worker quit and displayis it. 

%TIPS: As sort function you can use lists:sort,to merge 2 sorted lists you can use lists:merge,to divide the list you can use split/2: pass to it your list and N. 

 
%split(L,N)->  Len= length(L)div N, split(L,Len,N).
%split(L,_,1)-> [L];
%split(L,Len,N)-> LN=lists:sublist(L,Len),[LN]++split(L--LN,Len,N-1).

%2) create a functions end_work/1 that explicitly kills all the processes passed to it than prints a "work done" message on the console, modify master to use it to kill all the workers.
 
%3) modify the distpatcher so that, in case a worker dies, it restart a new one.  Modify the worker to exit with reason "unused" after 10sec of inactivity


 
split(L,N)->  Len= length(L)div N, split(L,Len,N).
split(L,_,1)-> [L];
split(L,Len,N)-> LN=lists:sublist(L,Len),[LN]++split(L--LN,Len,N-1).

send([],[],_,_)-> ok;			
send([PH|PT],[LH|LT],F,D)-> 
		io:format("Sent: ~p to ~p   \n",[LH,PH]),
		PH!{D,F,[LH]}, %% [LH] since apply expects a lists of args
		send(PT,LT,F,D).
		  
worker()-> 
	receive {PidD,Fun,Args}-> 
			%io:format("~p ~p   ~p  \n",[self(),Fun,Args]),
			PidD! {self(),apply(Fun,Args)},
			worker()
			after 10000 ->io:format("Suicide! ~p  \n",[self()]), exit("unused")
	end. 
			
master(N,L)-> 
	process_flag(trap_exit, true),
	PM=whereis(master),
	case PM of
	     undefined-> ok;
		_->unregister(master)
	end ,  %% this parts allows you to reuse the function from the same shell but use flush() first!
	register(master,self()),
	 
	Lists=split(L,N),
	%start workers
	WPids = lists:map(fun(_)->spawn_link(?MODULE, worker, [])end, Lists),
	
    % Starts Dispatcher;
    PidD = spawn_link(?MODULE,dispatcher,[WPids,length(L),[]]),
	io:format("Distpatcher: ~p  \n",[PidD]),
	
	send(WPids,Lists,fun lists:sort/1,PidD),
	
    % Waits for result;
   receive 
	
	{ok,PidD,R}-> end_work(WPids),
				io:format("Final Result:  \n",[]),R;

	quit-> 		end_work(WPids), 
				goodby;
	Undef->Undef
	end.	
				 	
dispatcher(Pids,ListsL,[]) ->
	receive 
			{_,Res}-> dispatcher(Pids,ListsL,[Res]) 
	end;
						
%% case end of processing	eg  [3,4,2,1] ---> Result=[[1,2,3,4]] 	 						
dispatcher(Pids,ListsL,Result) when length(hd(Result))==ListsL->
	 PM=whereis(master),
	 io:format("Dispatcher Result: ~p  \n",[Result]),
	 PM!{ok,self(),hd(Result)},
	 dispatcher(Pids,ListsL,[]);	
	 
	 
%% in between results 	 
dispatcher(Pids,ListsL,Result) ->
	 PM=whereis(master),	 
	 process_flag(trap_exit, true),
				
		receive 
		{'EXIT',Pid,"unused"} -> 
					WP=spawn_link(?MODULE, worker, []), io:format("Start ~p ~n",[WP]),
					dispatcher([Pid|Pids],ListsL,Result);
		{Pid,Res}->
				NR=[Res|Result],
				%io:format("Dispatcher processing: ~p  \n",[NR]),
				[NR1,NR2|NRT]=NR,
				Pid! {self(), fun lists:merge/2,[NR1,NR2]},
				dispatcher(Pids,ListsL,NRT)
		end. 

end_work(Pids) ->
	lists:foreach(fun(Process) -> exit(Process, kill) end, Pids),
	io:format("Work done ~p ~n",[Pids]).

