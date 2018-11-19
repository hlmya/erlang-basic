-module(e).
-compile(export_all).

count(L) -> count(L,[],L).

count([],Acc,_) -> lists:reverse(Acc);
count([H|T],Acc,L2) -> 
	{Smaller,Larger}=lists:foldl(fun(E,{S,L}) ->
						case H =/= E of
						true ->
						   case H > E of 
							  true ->  {S+1,L};
							  false ->  {S, L+1}
						   end;
						false -> {S,L}
						end end,
							 {0,0},L2),						  
	count(T,[{H,{Smaller,Larger}}|Acc],L2).


  

change(EmpId,Rise,Map) -> 
    case Map of
	  #{EmpId:={N,S}} -> {{N,S+Rise},Map#{EmpId=>{N,S+Rise}}};
	  _ -> {not_found,Map} end.


czip([],_) -> [];
czip(_,[]) -> [];
czip(L1,L2) -> czip(L1,L2,[],[],[]).

czip([],[],Acc,_,_) -> lists:reverse(Acc);
czip([],Y,Acc,[H|T],L2) -> czip([H],Y,Acc,T,L2);
czip(T,[],Acc,L1,[H|X]) -> czip(T,[H],Acc,L1,X);
czip([H|T],[X|Y],Acc,L1,L2) -> czip(T,Y,[{H,X}|Acc],L1++[H],L2++[X]).


select([]) -> [];
select(L) -> select(L,[]).

select([],Acc) -> Acc;
select([H|T],Acc) -> 
    case counter(H,[H|T],0) >= 3 of
    true -> select(lists:filter(fun(E) -> E/=H end,T),[H|Acc]);
	false -> select(lists:filter(fun(E) -> E/=H end,T),Acc)
	end.

counter(E,[],C) -> C;
counter(H,[H|T],C) -> counter(H,T,C+1);
counter(E,[H|T],C) -> counter(E,T,C).