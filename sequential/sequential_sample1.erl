-module(sequential_sample1).
-compile(export_all).
% sample SEQUENTIAL test 1
% =================================
% Task no. 1: 
% Ethiopian multiplication is a method of multiplying integers using only addition, doubling, and halving.
% Define three functions: 
	% one to halve an integer,
	% one to double an integer, and
	% one to state if an integer is even.
% Use them to create multiplier(L,R), that takes the two numbers (Left and Rigth) and compute their product in the following way:
	% Half the Left number until you get to 1, at the same time Double the Rigth number for the same amount of times. 
	% Discard any value from Rigth where the corresponding value in Left is even.
	% Sum all number left in right to produce the result of L*R.
 % Ex.   17    34            discard 68,136 and 272
        % 8    68 			34 + 544 == 17*34
        % 4   136 
        % 2   272 
        % 1   544
% %%%%%%%%%%%%#1  
% ~~~
% multiplier(integer(),integer()) -> integer()
% ~~~
% Test cases:
% ~~~
% test:multiplier(12,3)==(12*3).
% test:multiplier(0,0)== forbidden.
% test:multiplier(7,0)== forbidden.
% ~~~

halve(N) -> N div 2.

double(N) -> N * 2.

state(N) when N rem 2 == 0 -> true;
state(_) -> false.

%state -> return when left is odd
multiplier(L,R) -> multiplier(L, R, 0).

multiplier(0,_, _) -> forbidden;
multiplier(_,0, _) -> forbidden;
multiplier(1,R, Acc) -> Acc + R;
multiplier(L, R, Acc) ->
	case state(L) of
		true -> multiplier(halve(L), double(R), Acc);
		false -> multiplier(halve(L), double(R), Acc + R)
	end.

% ==========================
% Task no. 2: is_numeric/1

% Create the function is_numeric(S), that check if a given string is composed only by numbers 
% (Integer and Float is good), return true if the argument passed is either an integer or a float.
% **IMPORTANT:** you need to reimplement the function, 
% do not use the built-in function is_number/1. 
% ~~~
% is_numeric(S:list()) -> boolean()
% ~~~
% Test cases:
% -----------
% ~~~
% test:is_numeric("123") ==true.
% test:is_numeric("12.3")==true.
% test:is_numeric(".12.3")==false.
% test:is_numeric(".12.3.")==false.
% test:is_numeric("123.")==false.
% test:is_numeric("")==false.
% ~~~

list_is_integer([]) -> false;
list_is_integer(L) -> lists:all(fun(X)-> lists:member(X,lists:seq(48,57)) end, L).

list_is_float([]) -> false;
list_is_float(L) -> lists:all(fun(X)-> lists:member(X,lists:seq(48,57)++[46]) end, L) 
										andalso sample1:isProperDot(L) 
										andalso sample1:is_Not_Dot_ending(L)
										andalso sample1:is_Not_Dot_starting(L).



isProperDot(L) -> isProperDot(L,0).
isProperDot([H|T],Acc) ->
	case (H == $.) of
		true -> isProperDot(T, Acc + 1);
		false -> isProperDot(T, Acc)
	end;
	
isProperDot([], Acc) ->
	case (Acc =< 1) of 
		true -> true; % can create another condition? if else?
		false -> false
	end.

is_Not_Dot_starting([H|_]) ->
	case (H == $.) of
		true -> false;
		false -> true
	end.
is_Not_Dot_ending(L) -> is_Not_Dot_starting(lists:reverse(L)).
	
is_numeric(L) -> list_is_float(L) orelse list_is_integer(L).

	
% ==============================
% Task no. 3: replace/3
% Define the replace/3 function that takes three strings as arguments and
% replaces every other occurrence of the substring Old with New in Str.
% ~~~
% replace(Str::list(), Old::list(), New::list())-> list()
% ~~~
% Test cases:
% -----------
% ~~~
% test:replace("AppleAppleApple", "Apple", "Pear")=="PearApplePear"
% test:replace("AppleAppleApple", "Apple", "")=="Apple"
% test:replace("AppleAppleApple", "App", "Pear")=="PearleApplePearle"
% ~~~

replace_str(L,Old,New) ->
	Idx = string:str(L, Old),
	case Idx > 0 of
		true -> string:substr(L,1,Idx-1) ++ New;
		false -> L
	end.

replace(L,Old,New) -> replace(L, Old, New, 1, []).

replace(L, Old, New, Count, Acc) -> 
	case string:str(L, Old) > 0 of
		true -> 
			Idx = string:str(L,Old),
			Sub_second = string:substr(L,Idx + length(Old)),
			Sub_first = string:substr(L, 1, Idx + length(Old) - 1),
			case (Count rem 2) /= 0 of
				true -> replace(Sub_second, Old, New, Count+1, Acc ++ sample1:replace_str(Sub_first, Old, New));
				false -> replace(Sub_second, Old, New, Count+1, Acc ++ Sub_first)
			end;
		false -> Acc ++ L
	end.
	
%No 4
partition1(_,[],Smaller,Larger) -> {Smaller, Larger};
partition1(X,[H|T],Smaller,Larger) when X > H ->
	partition1(X, T, Smaller ++ [H], Larger);
partition1(X,[H|T],Smaller,Larger) when X =< H ->
	partition1(X, T, Smaller, Larger ++ [H]).
		
		
		
		
		
		
		
		
	






