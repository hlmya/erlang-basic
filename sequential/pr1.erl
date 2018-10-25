-module(pr1).
-compile(export_all).


%Lists : ... foldr/ foldl
%Map
%filter

% Week 1 2.7 Variables and patterns

same(X,X) -> 
	true;
same(_,_) ->
	false.

guard1(X, N) when X>=N ; N >= 0 ->
	true;
guard1(_,_) ->
	false.

guard2(X, N) when X>=N orelse N >= 0 ->
	true;
guard2(_,_) ->
	false.

incr(X) -> X + 1.

increment([]) -> [];
increment([H|T]) -> [H+1|increment(T)].

area({square, Side}) ->
	Side * Side;
area({circle, Radius}) ->
	3 * Radius * Radius;
area({triangle, A, B, C}) ->
	S = (A + B + C)/2,
	math:sqrt(S*(S-A)*(S-B)*(S-C));
area(Other) ->
	{invalid_object, Other}.
	
map1(_,[]) -> [];
map1(F,[H|T]) -> [F(H)| map1(F, T)].

insert(X, []) ->
	[X];
insert (X, L) ->
	case lists:member(X, L) of
		true -> L;
		false -> [X|L]
	end.

filter(Pred,L) -> filter1(Pred, L, []).

filter1(_, [], Acc) ->
	Acc;
filter1(Pred, [H|T], Acc) ->
	case Pred(H) of
		true -> filter1(Pred, T, [H|Acc]);
		false -> filter1(Pred, T, Acc)
	end.
	
max([H|T]) -> max1(T,H).

max1([],Max) -> Max;
max1([H|T], Max) ->
	case H > Max of
		true -> max1(T, H);
		false -> max1(T, Max)
	end.
	
% max1([],Max) -> Max;
% max1([H|T], Max) when H>Max -> max1(T,H);
% max1([_|T], Max) -> max1(T, Max).

sum(L) -> sum1(L,0).

sum1([], Acc) -> Acc;
sum1([H|T], Acc) -> sum1(T, H+Acc).
	
%fold(F, Acc, List)
foldl(_, Acc, []) -> Acc;
foldl(F,Acc, [H|T]) -> foldl(F, F(Acc, H), T).

%max by foldl
max2([H|T]) ->
	pr1:foldl(fun (A,B) when A > B -> A;
				 (_,B) 			  -> B end,
			H,
			T).

%Min by foldl
min2([H|T]) ->
	pr1:foldl(fun (A,B) when A < B -> A;
				 (_,B)			  -> B end,
				 H,
				 T).
				
%reverse by foldl
reverse2(L) ->
	foldl(fun (Acc,H) -> [H|Acc] end, [], L).
				
map2(F,L) ->
	foldl(fun (Acc,H) -> [F(H)|Acc] end, [], L).
				
filter2(Pred,L) ->
	F = fun (Acc, H) ->
			case Pred(H) of
				true -> [H|Acc];
				false -> Acc
			end
		end,
	foldl(F, [], L).

fac(0) -> 1;
fac(N) when N > 0 -> N * fac(N-1).

fac_t(N) -> fac_t(N, 1).

fac_t(0, Acc) -> Acc;
fac_t(N, Acc) when N > 0 -> fac_t(N-1, N*Acc).
				
len([]) -> 0;
len([_|T]) -> 1 + len(T).
				
len_t(L) -> len_t(L, 0).			

len_t([],Acc) -> Acc;
len_t([_|T], Acc) -> len_t(T, 1+Acc).

duplicate(0,_) -> [];
duplicate(N, Elem) when N > 0 ->
	[Elem|duplicate(N-1, Elem)].

duplicate1(N, Elem) -> duplicate1(N, Elem, []).

duplicate1(0, _, Acc) -> Acc;
duplicate1(N, Elem, Acc) when N > 0 ->
	duplicate1(N-1, Elem, [Elem | Acc]).
				
reverse_t(L) -> reverse_t(L,[]).

reverse_t([], Acc) -> Acc;
reverse_t([H|T], Acc) -> reverse_t(T, [H|Acc]).
				
sublist1(L, N) -> pr1:reverse_t(sublist1(L, N, [])).

sublist1(_, 0, Acc) -> Acc;
sublist1([], _, Acc) -> Acc;
sublist1([H|T], N, Acc) when N > 0 -> 
	sublist1(T, N-1, [H|Acc]).

zip1(Xs,Ys) -> lists:reverse(zip1(Xs, Ys, [])).

%Zip with any size of list
zip1(_,[], Acc) -> Acc;
zip1([],_, Acc) -> Acc;
zip1([X|Xs], [Y|Ys], Acc) -> 
	zip1(Xs, Ys, [{X,Y}|Acc]).

partition(Pred, L) -> partition(Pred, L, [], []).

partition(_, [], Satis, NotSatis) -> [Satis, NotSatis];
partition(Pred, [H|T], Satis, NotSatis) ->
	case Pred(H) of
		true -> partition(Pred, T, Satis ++ [H], NotSatis);
		false -> partition(Pred, T, Satis, NotSatis ++ [H])
	end.
				
quicksort([]) -> [];
quicksort([H|T]) ->
	{Smaller, Larger} = partition1(H,T,[],[]),
	quicksort(Smaller) ++ [H] ++ quicksort(Larger).
	
partition1(_,[],Smaller,Larger) -> {Smaller, Larger};
partition1(X,[H|T],Smaller,Larger) when X > H ->
	partition1(X, T, Smaller ++ [H], Larger);
partition1(X,[H|T],Smaller,Larger) when X =< H ->
	partition1(X, T, Smaller, Larger ++ [H]).

%dropwhile
%lists:dropwhile(fun(X)->X rem 2 == 0 end, [1,2,3,4]). //[1,2,3,4] Why not [1,3]???
%lists:takewhile(fun(X)->(X rem 2) == 0 end, [1,2,3,4]). //[]


%map: key


%freqency

%prime number
























