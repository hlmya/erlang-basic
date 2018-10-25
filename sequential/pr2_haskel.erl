%Exercise: http://lambda.inf.elte.hu/FL_FunDef_en.xml

-module(pr2_haskel).
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

























