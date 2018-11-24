-module(pr2).
-compile(export_all).

%ping-pong version 2 A() -> B() and B( -> A()

a() ->
	PidB = spawn(pr2, b(), []),
	PidB ! {self(), a},
	receive
		{PidBB, b} -> io:format("A() received~n",[]),
		a() % what different a() in receive and out receive
	end.
	
b() ->
	PidA = spawn(pr2,a(),[]),
	PidA ! {self(),b},
	receive
		{PidAA, a} -> io:format("B( received~n)",[])
	end,
	b().
	
%PidAA and PidBB are unused -> unecessary



	

