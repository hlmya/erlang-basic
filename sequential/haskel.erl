%Exercise: http://lambda.inf.elte.hu/FL_FunDef_en.xml
%Exercise from haskel page
-module(haskel).
-compile(export_all).

%==== Basic ====
%1. Generate the following list: [1, 2, …, n-1, n, n-1, …, 2, 1]
mountain(N) when N < 0 orelse N == 0 -> [];
mountain(N) when N > 0 ->
	List = lists:seq(1,N-1),
	List ++ [N] ++ lists:reverse(List).
	
%2. Given sides of a triangle as a, b, c, decide 
%whether the given triangle can be constructed.
areTriangleSides(A,B,C) ->
	case (A+B)>C andalso (A+C)>B andalso (B+C)>A of
		true -> true;
		false -> false
	end.

%3. Even or odd function -> negative is also integer
even(N) ->
	case N rem 2 == 0 of
		true -> true;
		false -> false
	end.
%4. Sum
sumSquaresTo(N) -> sumSquaresTo(N,0).

sumSquaresTo(N,_) when N < 0 -> 0;
sumSquaresTo(N,Acc) when N == 0 -> Acc;
sumSquaresTo(N, Acc) ->
	sumSquaresTo(N-1, math:pow(N,2) + Acc).

%5. Define a function, which given an integer n, 
%returns the positive divisors of n!
divisors(N) ->
	List = lists:seq(1,N),
	lists:filter(fun(X) -> N rem X == 0 end, List).

%==== Pair Patterns ====
% Calculate the distance of two points (x,y), (a,b)
distance({X1,Y1},{X2,Y2}) ->
	math:sqrt(math:pow(X2-X1,2) + math:pow(Y2-Y1,2)).

% Define a function that replaces all line breaks with spaces
replaceNewlines(L) -> replaceNewlines(L,[]).

replaceNewlines([], Acc) -> Acc;
replaceNewlines([H|T], Acc) ->
	case H == $\n of
		true -> replaceNewlines(T, Acc ++ " ");
		false -> replaceNewlines(T, Acc ++ [H])
	end.

% Define a function that replaces the words “this” and “that” and vice versa.
swapThisAndThat(L) -> 
	case string:equal(L, "this", true) orelse string:equal(L, "that", true) of
		true ->
			case string:equal(L, "this", true) of 
				true -> "that";
				false -> "this"
			end;
		false -> L
	end.

%Define a function that swaps all instances of “this” and “that”.
swapAllThisAndThat(L) -> swapAllThisAndThat(string:split(L," ", all),[]).

swapAllThisAndThat([], Acc) -> Acc;
swapAllThisAndThat([H|T], Acc) ->
	string:trim(swapAllThisAndThat(T, Acc ++ " " ++ swapThisAndThat(H))).

%==== Pattern Matching with Guards ====
% Redefined Prelude.take, which returns the first n elements of a list.
% ~ sublist()
take(N,L) -> take(N,L,[]).

take(0,_,Acc) -> Acc;
take(N,[H|T],Acc) when N > 0 andalso N =< length([H|T]) ->
	take(N-1, T, Acc ++ [H]);
take(N,L,_) when N > length(L) ->
	L;
take(N,_,_) when N < 0 ->
	[].

%unzip
unzip(L) -> unzip(L,{[],[]}).

unzip([], Acc) -> Acc;
unzip([H|T],{List1,List2}) ->
	{A,B} = H,
	unzip(T,{List1 ++ [A], List2 ++ [B]}).

% Redefine Prelude.splitAt which splits a list at the nth position!
splitAt(N, L) when N > 0 ->
	case N < length(L) of
		true -> {lists:sublist(L,N),lists:sublist(L,N+1,length(L))};
		false -> {L,[]}
	end;	
splitAt(N, L) when N =< 0 ->
	{[], L}.

%==== Higher-Order Functions ====
% Define count which counts elements with a given property.
count(F,L) -> count(F,L,0).
count(_,[],Acc) -> Acc;
count(F,[H|T],Acc) ->
	case F(H) of
		true -> count(F,T,Acc+1);
		false -> count(F,T,Acc)
	end.
		
% Redefine Prelude.takewhile
takewhile_t(F,L) -> takewhile_t(F,L,[]).

takewhile_t(_,[],Acc) -> Acc;
takewhile_t(F,[H|T],Acc) -> 
	case F(H) of
		true -> takewhile_t(F,T,Acc ++ [H]);
		false -> Acc
	end.

% Redefine the universal quantification (Prelude.all)
all(_,[]) -> true;
all(F, [H|T]) -> 
	case F(H) of
		true -> all(F,T);
		false -> false
	end.
		
%Redefine the existential quantification (Prelude.any).
any(_,[]) -> false;
any(F,[H|T]) ->
	case F(H) of
		true -> true;
		false -> any(F,T)
	end.

% Define the membership function (with the help of any) that determines if an element is member of a list.
member(_,[]) -> false;
member(Elem,[H|T]) ->
	case Elem == H of
		true -> true;
		false -> member(Elem,T)
	end.

%Redefine the Prelude.zipwith function.
zipwith(F,L1,L2) ->zipwith(F,L1,L2,[]).

zipwith(_,[],_,Acc) -> Acc;
zipwith(_,_,[],Acc) -> Acc;
zipwith(F,L1,L2,Acc) ->
	[H|T] = L1,
	[A|B] = L2,
	zipwith(F,T,B, Acc ++ [F(H,A)]).

% With the use of zipwith, implement a function that produces 
% the sequence of pairwise differences of elements for a list.
differences(L) ->
	haskel:zipwith(fun(X,Y)->Y-X end, L, tl(L)).

% Redefine the Prelude.span ~ splitwith
splitwith(F, L) ->
	{lists:takewhile(F,L), lists:dropwhile(F,L)}.

%~Group~This function splits a list into smaller sections that all contains equivalent elements.
group(L) -> group(L,[]).

group([],Acc) -> Acc;
group(L, Acc) ->
	{A,B} = lists:splitwith(fun(X) -> X == hd(L) end, L),
	group(B, Acc ++ [A]).

% Define the compress function that finds all repeated elements in a list 
% and packs them together with the number of their occurences as pairs.
compress(L) -> compress(haskel:group(L),[]).

compress([], Acc) -> Acc;
compress([H|T],Acc) ->
	N = length(H),
	R = {N, hd(H)},
	compress(T,Acc ++ [R]).

compress_t(L) -> compress_t(L,[]).

compress_t([],Acc) -> Acc;
compress_t(L, Acc) ->
	{A,B} = lists:splitwith(fun(X) -> X == hd(L) end, L),
	N = length(A),
	R = {N, hd(A)},
	compress_t(B, Acc ++ [R]).

%Define decompress, the inverse operation for the previously defined compress function
%[{N,a}]
decompress(L) -> decompress(L,[]).

decompress([],Acc) -> Acc;
decompress([H|T],Acc) ->
	{N,A} = H,
	decompress(T,Acc ++ lists:duplicate(N,A)).

%Redefine Prelude.iterate that iterates a function on a given element
% iterate(F,N) -> iterate(F,N,[]).

% iterate(F,N,Acc) ->
	% iterate (F,F(N),Acc ++ [N]),
	% Acc.

% take_iterate(N) -> 
	% lists:sublist(haskel:iterate(fun(X)->X*2 end,1), N).

fibPairs(N) -> fibPairs(N,[{0,1}]).

fibPairs(0,Acc) -> Acc;
fibPairs(N,Acc) ->
	{A,B} = lists:last(Acc),
	fibPairs(N-1, Acc ++ [{B, A+B}]).

% Define a function for extracting numbers from a string.
numbersInString(L) -> numbersInString(string:split(L," ",all),[]).

numbersInString([],Acc) -> Acc;
numbersInString([H|T], Acc) ->
	ListNumbers = lists:seq($0,$9),
	NewList = lists:filter(fun(X) -> member(X,ListNumbers) == true end,H),
	numbersInString(T,Acc ++ [NewList]).

%Find the longest word in a string.
longestWord(L) -> longestWord(string:split(L," ",all), {0,""}).

longestWord([], {_N,B}) -> B;
longestWord([H|T],Acc) ->
	{N,_B} = Acc,
	case length(H) >= N of
		true -> longestWord(T,{length(H),H});
		false -> longestWord(T, Acc)
	end.

% Count+1 because we dont cal the 1st element in the list T
frequent_elem([]) -> [];
frequent_elem([H|T]) -> 
	Pred = fun(X,{Count,ListRem}) when X == H -> {Count+1,ListRem};
			  (X,{Count,ListRem})			 -> {Count, [X|ListRem]}end,
	{Count,ListRem} = lists:foldl(Pred,{0,[]},[H|T]),
	[{Count, H} | frequent_elem(ListRem)].
% Frequent by map
frequent_map(L) -> frequent_map(L,#{}).

frequent_map([],Map) -> Map;
frequent_map([H|T], Map) ->
	case Map of %check element in Map
		#{H := OldValue} -> frequent_map(T,Map#{H => OldValue + 1}); % if there is existing H and value => value +1
		_ -> frequent_map(T, Map#{H => 1})	% if there are no existing element, put H with value 1
	end.

% Determine which character occurs the most in a string.
mostFrequentChar(L) ->
	FrequentList = haskel:frequent_elem(L),
	{_N,Char} = lists:max(FrequentList),
	Char.
	
% Determine at which index is the greatest element in the list. (The indexing shall start from 1.)
maxIndex(L) ->
	ZipList = lists:zip(L,lists:seq(1,length(L))),
	{_Max,Idx} = lists:max(ZipList),
	Idx.

% Construct the sequence 1, 11, 111, 1111, …
% numbersMadeOfOnes(N) -> numbersMadeOfOnes(N,[]).

% numbersMadeOfOnes(0,Acc) -> Acc;
% numbersMadeOfOnes(N,Acc) when N > 0 ->
	% numbersMadeOfOnes(N-1, [lists:concat(lists:duplicate(N,1))] ++ Acc).
one(N) -> [ones(lists:duplicate(X,1)) || X <- lists:seq(1,N)].

ones([_H|[]]) -> 1;
ones([_H|T]) -> trunc(math:pow(10,length(T))) + ones(T).
%Define: monogram "Jim Carrey" -> "J. C." :: String
monogram(L) -> monogram(string:split(L," ",all),[]).

monogram([],Acc) -> string:trim(Acc);
monogram([H|T], Acc) ->
	[A|_B] = H,
	monogram(T, Acc ++ [A] ++ ". ").

%Implement the function named uniq (as a composition) that eliminates all the redudant elements from a list.	
uniq(L) -> uniq(L, []).
uniq([], Acc) -> lists:sort(Acc);
uniq([H|T], Acc) -> 
	% do the same frequent_elem
	Pred = fun(X,ListRem) when X == H -> ListRem;(X,ListRem) -> [X|ListRem]end,
	Rem = lists:foldl(Pred,[],T), % get the rest list when reduce repeated elem
	uniq(Rem,Acc ++ [H]).

%Let repeated be a (composed) function that determines what elements occur more than once in a list.
repeated(L) -> repeated(L,[]).

repeated([], Acc) -> lists:sort(Acc);
repeated([H|T], Acc) ->
	Pred = fun(X,{Count,ListRem}) when X == H -> {Count+1,ListRem};
				(X,{Count,ListRem}) -> {Count, [X|ListRem]} end,
	{Count,ListRem} = lists:foldl(Pred,{0,[]},[H|T]),
	case Count > 1 of
		true -> repeated(ListRem, Acc ++ [H]);
		false -> repeated(ListRem, Acc)
	end.
	
repeated_1(L) -> repeated_1(lists:sort(L),[]).
repeated_1([], Acc) -> Acc;
repeated_1([H|T], Acc) ->
	Pred = fun(X) -> H == X end,
	{A,B} = lists:splitwith(Pred,[H|T]),
	case length(A) > 1 of
		true -> repeated_1(B,Acc ++ [hd(A)]);
		false -> repeated(B,Acc)
	end.





