-module(sequential_sample2).
-compile(export_all).
% Write a function which takes 2 inputs N and M. 
% N is the number you want to print M number of times repeatedly. 
% For example if N is 2 and M is 10 then the output 
% should be [2,22,222,2222,22222,222222,2222222,22222222,222222222,2222222222]

% No.1
% partition(list(),integer()) -> list(list())
% > re1:partition([1,2,3,4,5,6,7,8],2)== [[1,2],[3,4],[5,6],[7,8]].
% > re1:partition([1,2,3,4,5,6,7],2)== [[1,2],[3,4],[5,6],[7]].
% > re1:partition([1,2,3,4,5,6,7],4)== [[1,2,3,4],[5,6,7]].

partition(L,N) -> partition(L, N, []).

partition([], _, Acc) -> Acc;
partition(L, N, Acc) ->
	case N > 0 andalso length(L) >= N of
		true ->
			{L1,L2} = lists:split(N,L),
			partition(L2, N, Acc ++ [L1]);
		false -> Acc ++ [L]
	end.

% No.2
% Create a function combine(Funs,Value,Combine) that has three arguments: a list of functions (Funs), to apply
% to a single integer value (Value), and a function Combine that takes two elements at a time from the results of
% the functions, to combine all of them in a single value
% combine(list(fun()),integer(),fun()) -> integer()
% >re1:combine([fun(X)->X*2 end, fun(X)->X rem 2 end],fun(X,Y)-> X+Y end,1)== 3.
% >re1:combine([fun(X)->X*2 end, fun(X)->X rem 2 end],fun(X,Y)-> X-2*Y end,4)== 8.

combine(L, C, V) ->
	[Fun1, Fun2] = L,
	X = Fun1(V),
	Y = Fun2(V),
	C(X, Y).
	
%No.3
% Create a function inse(L,E), that returns all the possible insertions of an Element to a List
% inse(list(),integer()) -> list()
% >re1:inse([1,2,3],4)==[[4,1,2,3],[1,4,2,3],[1,2,4,3],[1,2,3,4]].
% >re1:inse([1,3],2)==[[2,1,3],[1,2,3],[1,3,2]].

inse([],N) -> [N];
inse(L, N) -> inse(L, N, length(L),[]).

inse(L, N, Idx, Acc) -> 
	case Idx >= 0 of
		true -> 
			R = pr2:insert_idx(L,N,Idx),
			inse(L, N, Idx-1,[R] ++ Acc);
		false -> Acc
	end.

insert_idx(L, N, Idx) -> 
	lists:sublist(L,Idx) ++ [N] ++ lists:sublist(L,Idx+1,length(L)).
	
% No. 4
% Create a function perm(L), that returns all the possible permutations for a list. 
% (Use the function inse/2 of Task3.)
% perm(list()) -> list(list())
% >re1:perm("abc")==["abc","bac","bca","cba","cab","acb"].
% >re1:perm([1,2])==[[1,2],[2,1]].
% >re1:perm([3,2,6])==[[3,2,6],[2,3,6],[2,6,3],[6,2,3],[6,3,2],[3,6,2]].


perm(L) -> perm(L, 1, []).

perm(L, Idx, Acc) ->
	case Idx =< length(L) of
		true ->
			Elem = take_idx(L,Idx),
			L2 = lists:delete(Elem, L),
			NewList = pr2:filter_duplicate(inse(L2, Elem), Acc),
			perm(L, Idx + 1, Acc ++ NewList);
		false -> 
			Acc
	end.

%Idx > 0
take_idx(L, Idx) ->
	case Idx > 0 andalso Idx =< length(L) of
		true -> 
			NewList = lists:sublist(L,Idx),
			lists:last(NewList);
		false -> 
			error
	end.

filter_duplicate(L, L1) -> filter_duplicate(L, L1, []).
filter_duplicate([], _, Acc) -> Acc;
filter_duplicate([H|T], L1, Acc) -> 
	case lists:member(H,L1) of
		true -> filter_duplicate(T, L1, Acc);
		false -> filter_duplicate(T, L1, Acc ++ [H])
	end.


% Frequency
frequency(L) -> frequency(L,[]).

frequency([],Acc) -> Acc;
frequency([H|T], Acc) ->
	Acc1 = Acc ++ count(H,T,1),
	NewList = pr2:delete(H,[H|T]),
	frequency(NewList,Acc1).

count(N, [], C) -> [{N,C}];
count(N,[H|T], C) -> 
	case N == H of
		true -> count(N,T, C+1);
		false -> count(N, T, C)
	end.
	

delete(N, L)-> delete(N, L, []).
delete(_, [], Acc) -> Acc;
delete(N, [H|T], Acc) ->
	case N == H of
		true -> delete(N, T, Acc);
		false -> delete(N, T, Acc ++ [H])
	end.
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	