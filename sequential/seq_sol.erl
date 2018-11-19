%
-module(seq_sol).
-compile(export_all).

%===== Sequential test 1 (2018-10-17) =====
%No.1
count(L) -> count(L, L, []).

count([],_, _) -> [];
count(_,[], Acc) -> Acc;
count(L,[H|T], Acc) ->
	% Smaller = lists:foldl(fun(X,C) when X < H -> C + 1;(_X,C) -> C end,
							% 0, L),
	% Greater = lists:foldl(fun(X,C) when X > H -> C + 1;(_X,C) -> C end,
							% 0, L),
	{Smaller,Greater} = lists:foldl(fun(X,{S,G}) ->
							case X =/= H of
								true ->
									case X < H of
										true -> {S+1,G};
										false -> {S,G+1}
									end;
								false ->
									{S,G}
							end
						end,{0,0},L),
	count(L,T,Acc ++ [{H,{Smaller,Greater}}]).

%No.2
change(EmpId, Rise, Map) ->
	case Map of
		#{EmpId:={Name,OldSalary}} -> {{Name,OldSalary + OldSalary*(Rise/100)},maps:update(EmpId,OldSalary + OldSalary*(Rise/100),Map)};
		_ -> {not_found,Map}
	end.
	
%No.3
c_zip([],_) -> [];
c_zip(_,[]) -> [];
c_zip(L1,L2) -> c_zip(L1,L2,[],[],[]).

c_zip([],[],Acc,_,_) -> Acc;
c_zip([],Y1,Acc,[H|T],Store2) -> c_zip([H],Y1,Acc,T,Store2);
c_zip(Y,[],Acc,Store1,[H|T]) -> c_zip(Y,[H],Acc,Store1,T);
c_zip([X|Y],[X1|Y1],Acc,Store1,Store2) -> c_zip(Y,Y1, Acc ++ [{X,X1}],Store1 ++ [X], Store2 ++ [X1]).

%No.4
select(L) -> select(L,[]).

select([],Acc) -> Acc;
select([H|T], Acc) ->
	Pred = fun(X,{Count,Rem}) when X == H -> {Count +1, Rem};
				(X,{Count,Rem}) -> {Count,[X|Rem]} end,
	{Count, Rem} = lists:foldl(Pred, {0,[]}, [H|T]),
	case Count >= 3 of
		true -> select(Rem, Acc ++ [H]);
		false -> select(Rem, Acc)
	end.

%===========================

%===== Sequential test (22.03.2018) =====
%No.1
halve(N) -> N div 2.

double(N) -> N * 2.

is_even(N) ->
	case N rem 2  == 0 of
		true -> true;
		false -> false
	end.
multiplier(0,_) -> forbidden;
multiplier(_,0) -> forbidden;
multiplier(L,R) -> multiplier(L,R,[]).

multiplier(1,R, Acc) -> lists:sum(Acc) + R;
multiplier(L,R, Acc) -> 
	case is_even(L) of
		true -> multiplier(halve(L), double(R), Acc);
		false -> multiplier(halve(L), double(R), Acc ++ [R])
	end.

%No.2
is_numeric([]) -> false;
is_numeric(L) ->
	case hd(L) == $. orelse lists:last(L) == $. of
		true -> false;
		false -> is_numeric(L,0)
	end.
		
% is_numeric([$.|_]) -> false; %check starting dot
% is_numeric(L) -> is_numeric(L,0).

% is_numeric([$.],_) -> false; %check ending dot

is_numeric([],Dot) ->
	case Dot > 1 of
		true -> false;
		false -> true
	end;
is_numeric([H|T],Dot) ->
	case lists:member(H,lists:seq($0,$9)) of
		true -> is_numeric(T,Dot);
		false ->
			case H == $. of
				true -> is_numeric(T,Dot+1);
				false -> false
			end
	end.

%No.3
replace(L,Old,New)-> 
	NewList = string:split(L,Old,all),
	ZipList = lists:zip(NewList,lists:seq(1,length(NewList))),
	replace(ZipList,Old,New,[]).

replace([],_,_,Acc) -> Acc;
replace([H|T],Old,New,Acc) -> 
	{String,Idx} = H,
	case Idx rem 2 =/= 0 of
		true -> 
			case Idx == 1 of
				true -> replace(T,Old,New,Acc ++ String);
				false -> replace(T,Old,New,Acc ++ Old ++ String)
			end;
		false -> replace(T,Old,New,Acc ++ New ++ String)
	end.
	
%No.4
partition(Pred,L) -> partition(Pred,L,[],[]).
partition(_,[],Satis,NoSatis) -> [Satis,NoSatis];
partition(Pred,[H|T],Satis,NoSatis) ->
	case Pred(H) of
		true -> partition(Pred,T,Satis++[H],NoSatis);
		false -> partition(Pred,T,Satis,NoSatis++[H])
	end.























