-module(bike).
-compile(export_all).

%bike , size  (1 to 4), price , available/Pid
%{bike001,2,10,available},
%{bike002,1,10,{<0.92.0>,"c@localhost"}}

% Client interface ==========

getAvailableBikes(N_seats) ->
	global:send(server,{seat,self(),N_seats}).

rent(BikeId) ->
	global:send(server,{rent, self(),BikeId).

return(Wallet) ->
	global:send(server,{return, self(), Wallet}).

% Server implementation =================

start(N) ->
	Bikes = initBike(N),
	register(server, spawn(fun()-> loop(Bikes,0) end)).
	
loop(Bikes, Cash) ->
	receive
		stop ->
			io:format("Server terminated!~n");
		state ->
			io:format("List of bikes: ~p and Cashflow: ~p ~n",[Bikes,Cash]),
			loop(Bikes,Cash);
		
	end.
	
initBike(N) ->
	initBike(1,N,[]).
initBike(_,0,Acc) -> Acc;
initBike(Id,N,Acc) ->
	NewAcc = Acc ++ [{gen_id(Id),rand:uniform(4), crypto:rand_uniform(10,100),available}],
	initBike(Id+1, N-1, NewAcc).

gen_id(Id) ->
	"bike" ++ integer_to_list(Id).
	
