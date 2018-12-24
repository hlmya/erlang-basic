-module(bike_client).
-export([start/1, stop/0, incident/0]).

start(Wallet) ->
	case whereis(bike_client) == undefined of
		true -> void;
		false -> exit(whereis(bike_client), terminate),
			   unregister(bike_client)
    end,
    register(bike_client,spawn(fun() -> loop(Wallet) end)).

loop(Wallet) ->
    Passenger = rand:uniform(4),
    getAvailableBikes(Passenger),
    receive
        stop -> 
			exit(normal), io:format("Client stopped~n");
		[] -> 
			io:format("no empty bikes ~n"),
			timer:sleep(5000),
			loop(Wallet);
		incident ->
			{bike_server, 'server@Y4'} ! {incident, self(), Wallet},
			receive 
				{incident, NewWallet} -> loop(NewWallet);
				_ -> void
			end;
		Bikes ->
			{Bid,_,Price,_} = choose_cheapest(Bikes),
			io:format("Possible bikes for ~p :~n ~p~n",[Passenger,Bikes]),
			case Wallet >=  Price of
				true ->
					rent(Bid),
					receive
						{rented, BikeId} -> 
						io:format(" Having a trip on ~p: at ~p ~n",[BikeId,calendar:now_to_local_time(erlang:timestamp())]),
						timer:sleep(60000),
						NewWallet = return(Wallet),
						loop(NewWallet)
					end;
				false  -> 
					io:format("Not enough money ~n ~p to pay ~p~n",[Wallet,Price]),
					exit(normal)
			end
    end.

getAvailableBikes(N_seats) ->
    {bike_server, 'server@Y4'} !  {bike, self(), N_seats}.

rent(BikeId) ->
    {bike_server, 'server@Y4'} !  {rent, self(), BikeId}.

return(Wallet) ->
    {bike_server, 'server@Y4'} !  {wallet, self(), Wallet},
     receive 
	{wallet, NewWallet} -> NewWallet;
	_  -> Wallet
    end.

choose_cheapest([H|[]]) -> H;
choose_cheapest([H|Bikes]) -> 
    lists:foldl(fun({_,_,Pr2,_}= Bike, {_,_,Pr1,_}= Acc) ->
			case Pr1 > Pr2 of
			    true -> Bike;
			    false -> Acc
			end
		end,H,Bikes).

stop() ->
   case whereis(bike_client) /= undefined of
  true -> bike_client ! stop;
  false -> already_stopped
  end.

incident() ->
	case whereis(bike_client) /= undefined of
		true -> bike_client ! incident;
		false -> bike_client_stopped
	end.
