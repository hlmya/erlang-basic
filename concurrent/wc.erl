-module(wc).
-compile([export_all]).


% mapReduce(M,Text): 

% 1-starts a Reduce process that take MapReduce ProcessId and has a temporary list where to store the word count
% 2-starts all the M Map, passing them the R reducer ProcessId
% 3-For each line of input data  it randomly pick one of the M mapper processes and send the line to it (you can use string:tokens(Text, "\n"). to separate lines)

% 4-Waits for final result from the reduce process
% 5-Kills all the workers and the reduce
% 6-Return the collected result


 mapReduce(M,Text)->
	%process_flag(trap_exit,true),
     RedPid= spawn(?MODULE,reduce,[self(),[]]),
	 MapPids= lists:map(fun(_)->  spawn(fun()-> map(RedPid)end) end,lists:seq(1,M)),
	 L=string:tokens(Text, "\n"),
	 send(MapPids,L),
	receive
			{ok,RedPid,Result}-> killAll([RedPid|MapPids]), Result
	end.
	
send(_,[])->ok;	
send(MP, [LH|LT])-> 
	Pid=lists:nth(rand:uniform(length(MP)),MP),
	Pid!{map, LH},
	send(MP,LT).
	
	
% The map(ReducePid) :

% 1-Receive the input line
% 2-separate all worlds in the line and put them in a tuple {Word, 1} 
% (you do not have to handle special cases like having puctuation attached to a word or plurals, just consider the line as a long lists of characters separated by spaces, use string:tokens to get a list of words) 
% 3-send a tuple at a time to the reducer
map(RPid)->
	receive 
		{map, L}-> Words= string:tokens(L," "),
		lists:foreach(fun(W)-> RPid! {W,1} end,Words), 
		map(RPid)
	end.

% the reduce(MapReducePid,currentResult):

% 1- Receive the key, value from the Mapper process ({Word,1})
% 2- Get the current accumulated value by the key. 
% 3- If no accumulated value is found, just append to the result the tuple.
% 4- if it finds it, update the word count of 1
% 5- Store the new accumulated value under the key
% 6- Repeat until it does not receive any more message for 2 secondsin a row
% 7- print "I am done!" and send the result to mapReduce

reduce(MapReducePid,CResult)-> 
	receive 
		{W,1}-> Exist=lists:keyfind(W,1,CResult),
				NewRes= case Exist of 
				 false-> [{W,1}|CResult];
				 {W,N}-> lists:keyreplace(W,1,CResult,{W,N/0}) 
				 end,
				reduce(MapReducePid,NewRes)
				
	after 2000-> io:format("I am done! ~n", []),
			MapReducePid! {ok,self(),CResult}
	end.
	
killAll(Pids)->
    lists:foreach(fun(ProcessId)-> exit(ProcessId, kill)end,Pids),
	io:format("Killed ~p ~n",[Pids]).
% Practical example:

	% mapReduce(2,"example \n example for you\n you see")