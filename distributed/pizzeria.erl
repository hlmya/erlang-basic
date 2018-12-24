-module(pizzeria).
-export([open/0, close/0, order/2, where_is_my_pizza/1]).

% restaurant

open() ->
	register(pizzeria, spawn(fun() -> pizzeria([]) end)).

close() ->
	pizzeria ! close.

cook(Pizza) when Pizza == margherita orelse Pizza == calzone ->
	case Pizza of
		margherita -> timer:sleep(500);
		calzone -> timer:sleep(600)
	end.

pizzeria(Orders) ->
	receive
		close ->
			close;
			
		{order, Client, Pizza} ->
			{_Pid,RefOrder} = spawn_monitor(fun()-> cook(Pizza) end),
			UpdatedOrders = Orders ++ [{RefOrder,Client,Pizza}],
			pizzeria(UpdatedOrders);
			
		{'DOWN',RefOrder,_,_,_} ->
			{_,Client,Pizza} = lists:keyfind(RefOrder,1,Orders),
			Client ! {delivered, Pizza},
			UpdatedOrders = lists:keydelete(RefOrder,1,Orders),
			pizzeria(UpdatedOrders);
			
		{what_takes_so_long, Client} ->
			case lists:keyfind(Client,2,Orders) of
				{_Ref,_Cpid,Pizza} -> 
					Client ! {cooking, Pizza};
				false ->
					Client ! nothing_was_ordered
			end,
			pizzeria(Orders)
	end.

% client

order(Pizza, Node) ->
	{pizzeria,Node} ! {order, self(), Pizza}.

where_is_my_pizza(Node) ->
	{pizzeria,Node} ! {what_takes_so_long, self()}.