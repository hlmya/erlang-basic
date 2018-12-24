-module(bike_server).
-export([start/1, stop/0,loop/3]).

start(N) ->
    Bikes = initBike(N),
    register(bike_server,spawn(fun() -> init(Bikes, 0) end)).

stop() ->
    bike_server ! stop.

init(Bikes, Cash) ->
    loop(Bikes, Cash,0).

loop(Bikes, Cash, Complain_Counter) ->
    %io:format("Server state: Bikes:~p Cash:~p Com: ~p~n",[Bikes,Cash, Complain_Counter]),
    receive
		stop -> 
			exit(normal), io:format("Server stopped~n");
		upgrade -> 
			bike_server:loop(Bikes,Cash,Complain_Counter);
		unsatisfied -> 
			case Complain_Counter == 4 of
				true -> loop([buyBike(length(Bikes))|Bikes], Cash-100,0);
				false -> loop(Bikes, Cash, Complain_Counter+1)
			end; 
		state  -> 
			io:format("Bikes ~p, Cash ~p~n",[Bikes, Cash]), loop(Bikes, Cash,  Complain_Counter);
		{bike, Pid, N_seats}   -> 
			bikeQuery(Pid, N_seats, Bikes),
			loop(Bikes, Cash,  Complain_Counter);
		{rent, Pid, BikeId}	 ->  
			NewBikes = handle_rent(BikeId, Pid, Bikes),
			loop(NewBikes, Cash,  Complain_Counter);
		{wallet, Pid, Wallet } -> 
			{NewBikes, Gain} = return(Wallet,Pid, Bikes),
			io:format("Gained ~p ~n",[Gain]),
			loop(NewBikes, Gain+Cash, Complain_Counter);
		{incident, Pid, CWallet}  -> 
			Pid ! {incident, CWallet-100},
			NewBikes=lists:keydelete(Pid,4,Bikes),
			loop(NewBikes, Cash+100, Complain_Counter)
    end.	   

bikeQuery(Pid,N_seats,Bikes) ->
    ABikes = lists:foldl(fun({_, Size, _,Tuple}=Bike,Acc) -> 
				 if
				     Size >= N_seats andalso Tuple == available -> [Bike|Acc];
				     true  -> Acc
				 end
			 end,[],Bikes),
    Pid ! ABikes.

handle_rent(BikeId, Pid, Bikes) ->
    lists:map(fun({Bid,Size, Pr, Tuple}) -> 
		      if
			  BikeId == Bid andalso Tuple == available ->
			      Pid ! {rented, BikeId},
			      io:format("Rented bike ~p to ~p~n",[BikeId,Pid]),
			      {Bid, Size, Pr, Pid};
			  true  -> {Bid, Size, Pr, Tuple}
		      end
	      end,Bikes).

return(Wallet,Pid, Bikes) ->
    case lists:keyfind(Pid,4,Bikes) of
	{BikeId, Size, Price, Pid} ->  Pid ! {wallet, Wallet-Price},
				       {lists:keyreplace(Pid, 4, Bikes,{BikeId, Size, Price, available}), Price};
	false -> Pid ! 'Not rented bike',
		 {Bikes, 0}
    end.

initBike(N) -> initBike(1,N).

initBike(_Id,0) -> [];    
initBike(Id,N) ->
    [{gen_id(Id),rand:uniform(4),crypto:rand_uniform(10,100),available}|initBike(Id+1,N-1)].

buyBike(Id) ->
    hd(initBike(Id+1,1)).

gen_id(Id) when Id < 10 ->  list_to_atom("bike \0"++integer_to_list(Id));
gen_id(Id) when Id < 100  -> list_to_atom("bike \0" ++integer_to_list(Id));
gen_id(Id) -> list_to_atom("bike \0"++integer_to_list(Id)).


