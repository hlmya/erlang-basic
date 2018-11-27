-module(fifth).

-compile(export_all).

%% third:count
count(X, L) -> 
	Values = lists:map(fun(E) when E == X ->
							1;
						  (_) ->
							0
						end, L),
	lists:sum(Values).


prod([H|T]) ->
	H * prod(T);
prod([]) ->
	1.
	
prod_tail(L) ->
	prod_tail(L, 1).
	
prod_tail([H|T], Acc) ->
	prod_tail(T, Acc * H);
prod_tail([], Acc) ->
	Acc.

prod_fold(L) ->
	lists:foldl(fun(H, Acc) ->
					Acc * H
				end, 1, L).
	
count_split_tail(Val, L) ->
	count_split_tail(Val, L, {0, []}).
	
count_split_tail(Val, [Val|T], {Count, Rem}) ->
	count_split_tail(Val, T, {Count+1, Rem});
count_split_tail(Val, [H|T], {Count, Rem}) ->
	count_split_tail(Val, T, {Count, [H |Rem]});
count_split_tail(_, [], Result) ->
	Result.


count_split(_, []) ->
	{0, []};
count_split(Val, [Val | T]) ->
	{Count, Rem} = count_split(Val, T),
	{Count + 1, Rem};
count_split(Val, [H|T]) ->
	{Count, Rem} = count_split(Val, T),
	{Count, [H | Rem]}.

count([]) ->
	[];
count([H|T]) ->
	%Rem = lists:filter(fun(E) -> E /= H end, T ),
	%Count = third:count(H, T),
	%{Count, Rem} = count_split(H, T),
	%{Count, Rem} = count_split_tail(H, T),
	{Count, Rem} = lists:foldl(fun(E, {Count, Rem}) when E == H ->
									{Count +1, Rem};
								  (E, {Count, Rem}) ->
									{Count, [E | Rem]}
								end, {0, []}, T),
	[{H, Count +1 } | count(Rem)].

count3(List) ->
	count_map(List, #{}).
	
count_map([], Map) ->
	Map;
count_map([H|T], Map) ->
	case Map of 
		#{H:=OldCount} -> count_map(T, Map#{H=>OldCount+1});
		_ -> count_map(T, Map#{H=>1})
	end.
	
	%Last login: Mon Oct  8 08:37:43 on ttys001
%melindas-mbp:fp2 melindatoth$ cd ..
%melindas-mbp:Desktop melindatoth$ cd dds
%melindas-mbp:dds melindatoth$ erl
%Erlang/OTP 20 [erts-9.0] [source] [64-bit] [smp:4:4] [ds:4:4:10] [async-threads:10] [hipe] [kernel-poll:false] [dtrace]

%Hello Melinda
%Eshell V9.0  (abort with ^G)
%1> Map = #{apple => 2, pear=> 3}.
%#{apple => 2,pear => 3}
%2> #{apple := Count} = Map.
%#{apple => 2,pear => 3}
%3> Count.
%2
%4> maps:get(apple, Map).
%2
%5> Map = #{apple => 2, pear=> 3}.
%#{apple => 2,pear => 3}
%6> maps:get(apple, Map).         
%2
%7> Map = #{apple => 2, pear=> 3}.
%#{apple => 2,pear => 3}
%8> maps:get(apple, Map).         
%2
%9> #{apple := Count} = Map.      
%#{apple => 2,pear => 3}
%10> c(fifth).
%fifth.erl:3: Warning: export_all flag enabled - all functions will be exported
%{ok,fifth}
%11> fifth:count([3,3,1,1,3]).
%[{3,3},{3,2},{1,2},{1,1},{3,1}]
%12> c(fifth).                
%fifth.erl:3: Warning: export_all flag enabled - all functions will be exported
%{ok,fifth}
%13> fifth:count([3,3,1,1,3]).
%[{3,3},{1,2}]                      
%14> c(fifth).                
%fifth.erl:3: Warning: export_all flag enabled - all functions will be exported
%{ok,fifth}
%15> fifth:count([3,3,1,1,3]).
%[{3,3},{1,2}]
%16> fifth:count_split(3, [3,3,1,1,3]).
%{3,[1,1]}
%17> c(fifth).                         
%fifth.erl:14: function prod/2 undefined
%fifth.erl:3: Warning: export_all flag enabled - all functions will be exported
%error
%18> c(fifth).
%fifth.erl:3: Warning: export_all flag enabled - all functions will be exported
%{ok,fifth}
%19> fifth:count_split_tail(3, [3,3,1,1,3]).
%{3,[1,1]}
%20> fifth:count_split_tail(3, [3,2,3]).    
%{2,[2]}
%21> fifth:count([3,3,1,1,3]).              
%[{3,3},{1,2}]
%22> fifth:count([3,2,3]).    
%[{3,2},{2,1}]
%23> lists:map(fun(X) -> X+2 end, [3,4]).
%[5,6]
%24> lists:map(fun(X) when X == 3 -> 1 end, [3,4]).
%** exception error: no function clause matching 
                    %erl_eval:'-inside-an-interpreted-fun-'(4) 
%25> c(fifth).                                     
%fifth.erl:52: function count/1 already defined
%fifth.erl:3: Warning: export_all flag enabled - all functions will be exported
%error
%26> c(fifth).
%fifth.erl:3: Warning: export_all flag enabled - all functions will be exported
%{ok,fifth}
%27> fifth:count(3, [3,4,5]).
%[1,0,0]
%28> c(fifth).               
%fifth.erl:3: Warning: export_all flag enabled - all functions will be exported
%{ok,fifth}
%29> fifth:count(3, [3,4,5]).
%1
%30> fifth:count(3, [3,4,5,3,3]).
%3
%31> c(fifth).                   
%fifth.erl:3: Warning: export_all flag enabled - all functions will be exported
%{ok,fifth}
%32> fifth:prod_
%prod_fold/1  prod_tail/1  prod_tail/2  
%32> fifth:prod_tail([3,4,5]).
%60
%33> fifth:prod_fold([3,4,5]).
%60
%34> c(fifth).                
%fifth.erl:3: Warning: export_all flag enabled - all functions will be exported
%{ok,fifth}
%35> fifth:count(3, [3,4,5,3,3]).
%3
%36> fifth:count([3,4,5,3,3]).   
%[{3,3},{5,1},{4,1}]
%37> c(fifth).                   
%fifth.erl:3: Warning: export_all flag enabled - all functions will be exported
%fifth.erl:66: Warning: variable 'H' is unused
%fifth.erl:66: Warning: variable 'H' shadowed in 'fun'
%fifth.erl:68: Warning: this clause cannot match because a previous clause at line 66 always matches
%{ok,fifth}
%38> 
