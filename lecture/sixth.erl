-module(sixth).
-compile(export_all).

fib(0) ->
	1;
fib(1) ->
	1;
fib(N) ->
	fib(N-1) + fib(N-2).
	
call(List) ->
	lists:map(fun fib/1, List),
	lists:map(fun(X) -> sixth:fib(X) end, List),
	lists:map(fun(X) -> apply(sixth, fib, [X]) end, List).
	
call_par(List) ->
	MyPid = self(),
	lists:map(fun(X) -> spawn(fun() -> MyPid ! sixth:fib(X) end) end, List).

eval() ->
	try 
		{ok, Mod} = io:read("Module name: "),
		Exported = Mod:module_info(exports),
		{ok, Fun} = io:read("Function name: "),
		{Fun, Arity} = lists:keyfind(Fun, 1, Exported),
		Arguments =
			lists:map(fun(_) -> 
						{ok, Par} = io:read("Give me an argument: "),
						Par
					end, lists:seq(1, Arity)),
		%Mod:Fun(lists:nth(1, Arguments), lists:nth(2, Arguments))
		apply(Mod, Fun, Arguments)
	of 
		Value -> Value
	catch
		_:{badmatch, false} -> "Non existing function";
		_:{badmatch, _} -> "Bad term";
		_:undef -> "Non existing module"
		%_:_ -> {Mod, Fun, Arity}
	end.

eval_try(Fun) ->
	try Fun([]) 
	of
		Value -> {result, Value}
	catch
		error:{badfun, _} -> error;
		_:_ -> other_error
	end.

eval_fun(Fun) ->
	case catch Fun([]) of
		{'EXIT', {{badfun, _Value}, _StackTrace}} ->
			error;
		{'EXIT', _} ->
			other_error;
		Value ->
			{result, Value}
	end.
	
exit_fun(_) ->
	{'EXIT', 1}.

%Last login: Tue Oct 16 07:18:37 on ttys001
%Melindas-MacBook-Pro:~ melindatoth$ cd Desktop/dds
%Melindas-MacBook-Pro:dds melindatoth$ erl
%Erlang/OTP 20 [erts-9.0] [source] [64-bit] [smp:4:4] [ds:4:4:10] [async-threads:10] [hipe] [kernel-poll:false] [dtrace]

%Hello Melinda
%Eshell V9.0  (abort with ^G)
%1> length([3,4]).
%2
%2> length([]).   
%0
%3> length(2). 
%** exception error: bad argument
     %in function  length/1
        %called as length(2)
%4> catch length(2).
%{'EXIT',{badarg,[{erlang,length,[2],[]},
                 %{erl_eval,do_apply,6,[{file,"erl_eval.erl"},{line,674}]},
                 %{erl_eval,expr,5,[{file,"erl_eval.erl"},{line,431}]},
                 %{shell,exprs,7,[{file,"shell.erl"},{line,687}]},
                 %{shell,eval_exprs,7,[{file,"shell.erl"},{line,642}]},
                 %{shell,eval_loop,3,[{file,"shell.erl"},{line,627}]}]}}
%5> catch length([]).
%0
%6> catch apple:apple().
%{'EXIT',{undef,[{apple,apple,[],[]},
                %{erl_eval,do_apply,6,[{file,"erl_eval.erl"},{line,674}]},
                %{erl_eval,expr,5,[{file,"erl_eval.erl"},{line,431}]},
                %{shell,exprs,7,[{file,"shell.erl"},{line,687}]},
                %{shell,eval_exprs,7,[{file,"shell.erl"},{line,642}]},
                %{shell,eval_loop,3,[{file,"shell.erl"},{line,627}]}]}}
%7> catch X =2.         
%2
%8> catch X =3.
%{'EXIT',{{badmatch,3},[{erl_eval,expr,3,[]}]}}
%9> catch lists:max([]).
%{'EXIT',{function_clause,[{lists,max,
                                 %[[]],
                                 %[{file,"lists.erl"},{line,328}]},
                          %{erl_eval,do_apply,6,
                                    %[{file,"erl_eval.erl"},{line,674}]},
                          %{erl_eval,expr,5,[{file,"erl_eval.erl"},{line,431}]},
                          %{shell,exprs,7,[{file,"shell.erl"},{line,687}]},
                          %{shell,eval_exprs,7,[{file,"shell.erl"},{line,642}]},
                          %{shell,eval_loop,3,
                                 %[{file,"shell.erl"},{line,627}]}]}}
%10> catch 1/0.
%{'EXIT',{badarith,[{erlang,'/',[1,0],[]},
                   %{erl_eval,do_apply,6,[{file,"erl_eval.erl"},{line,674}]},
                   %{erl_eval,expr,5,[{file,"erl_eval.erl"},{line,431}]},
                   %{shell,exprs,7,[{file,"shell.erl"},{line,687}]},
                   %{shell,eval_exprs,7,[{file,"shell.erl"},{line,642}]},
                   %{shell,eval_loop,3,[{file,"shell.erl"},{line,627}]}]}}
%11> catch 1 + atom.
%{'EXIT',{badarith,[{erlang,'+',[1,atom],[]},
                   %{erl_eval,do_apply,6,[{file,"erl_eval.erl"},{line,674}]},
                   %{erl_eval,expr,5,[{file,"erl_eval.erl"},{line,431}]},
                   %{shell,exprs,7,[{file,"shell.erl"},{line,687}]},
                   %{shell,eval_exprs,7,[{file,"shell.erl"},{line,642}]},
                   %{shell,eval_loop,3,[{file,"shell.erl"},{line,627}]}]}}
%12> catch 1 + $a.  
%98
%13> Fun = fun lists:max/1.
%#Fun<lists.max.1>
%14> catch Fun([3]).
%3
%15> catch Fun([]). 
%{'EXIT',{function_clause,[{lists,max,
                                 %[[]],
                                 %[{file,"lists.erl"},{line,328}]},
                          %{erl_eval,do_apply,5,
                                    %[{file,"erl_eval.erl"},{line,661}]},
                          %{erl_eval,expr,5,[{file,"erl_eval.erl"},{line,431}]},
                          %{shell,exprs,7,[{file,"shell.erl"},{line,687}]},
                          %{shell,eval_exprs,7,[{file,"shell.erl"},{line,642}]},
                          %{shell,eval_loop,3,
                                 %[{file,"shell.erl"},{line,627}]}]}}
%16> catch Fun([], 2).
%{'EXIT',{{badarity,{#Fun<lists.max.1>,[[],2]}},
         %[{shell,apply_fun,3,[{file,"shell.erl"},{line,902}]},
          %{erl_eval,do_apply,5,[{file,"erl_eval.erl"},{line,661}]},
          %{erl_eval,expr,5,[{file,"erl_eval.erl"},{line,431}]},
          %{shell,exprs,7,[{file,"shell.erl"},{line,687}]},
          %{shell,eval_exprs,7,[{file,"shell.erl"},{line,642}]},
          %{shell,eval_loop,3,[{file,"shell.erl"},{line,627}]}]}}
%17> Int = 1.
%1
%18> catch Int([], 2).
%{'EXIT',{{badfun,1},
         %[{shell,apply_fun,3,[{file,"shell.erl"},{line,902}]},
          %{erl_eval,do_apply,5,[{file,"erl_eval.erl"},{line,661}]},
          %{erl_eval,expr,5,[{file,"erl_eval.erl"},{line,431}]},
          %{shell,exprs,7,[{file,"shell.erl"},{line,687}]},
          %{shell,eval_exprs,7,[{file,"shell.erl"},{line,642}]},
          %{shell,eval_loop,3,[{file,"shell.erl"},{line,627}]}]}}
%19> catch Fun([], 2). 
%{'EXIT',{{badarity,{#Fun<lists.max.1>,[[],2]}},
         %[{shell,apply_fun,3,[{file,"shell.erl"},{line,902}]},
          %{erl_eval,do_apply,5,[{file,"erl_eval.erl"},{line,661}]},
          %{erl_eval,expr,5,[{file,"erl_eval.erl"},{line,431}]},
          %{shell,exprs,7,[{file,"shell.erl"},{line,687}]},
          %{shell,eval_exprs,7,[{file,"shell.erl"},{line,642}]},
          %{shell,eval_loop,3,[{file,"shell.erl"},{line,627}]}]}}
%20> Map = #{}.
%#{}
%21> Map#{apple=> 2}.
%#{apple => 2}
%22> catch Int#{apple=> 2}.
%{'EXIT',{{badmap,1},
         %[{maps,put,[k,v,1],[]},
          %{erl_eval,expr,5,[{file,"erl_eval.erl"},{line,251}]},
          %{erl_eval,expr,5,[{file,"erl_eval.erl"},{line,431}]},
          %{shell,exprs,7,[{file,"shell.erl"},{line,687}]},
          %{shell,eval_exprs,7,[{file,"shell.erl"},{line,642}]},
          %{shell,eval_loop,3,[{file,"shell.erl"},{line,627}]}]}}
%23> Int#{apple=> 2}.      
%** exception error: {badmap,1}
     %in function  maps:put/3
        %called as maps:put(k,v,1)
%24> c(sixth).             
%sixth.erl:2: Warning: export_all flag enabled - all functions will be exported
%{ok,sixth}
%25> Fun.  
%#Fun<lists.max.1>
%26> sixth:eval_fun(Fun).
%other_error
%27> Fun1=lists:sum/1.
%* 1: illegal expression
%28> Fun1= fun lists:sum/1.
%#Fun<lists.sum.1>
%29> sixth:eval_fun(Fun1). 
%{result,0}
%30> Int.                 
%1
%31> sixth:eval_fun(Int). 
%error
%32> c(sixth).             
%sixth.erl:2: Warning: export_all flag enabled - all functions will be exported
%{ok,sixth}
%33> Fun2= fun sixth:exit_fun/1.
%#Fun<sixth.exit_fun.1>
%34> sixth:eval_fun(Fun2).      
%other_error
%35> 1/0.
%** exception error: an error occurred when evaluating an arithmetic expression
     %in operator  '/'/2
        %called as 1 / 0
%36> throw(apple).
%** exception throw: apple
%37> c(sixth).                  
%sixth.erl:2: Warning: export_all flag enabled - all functions will be exported
%{ok,sixth}
%38> sixth:eval_try(Fun2).
%** exception error: undefined function sixth:eval_try/1
%39> c(sixth).            
%sixth.erl:2: Warning: export_all flag enabled - all functions will be exported
%{ok,sixth}
%40> sixth:eval_try(Fun2).
%{result,{'EXIT',1}}
%41> io:read("Module name: ").
%Module name: lists.
%{ok,lists}
%42> io:read("Module name: ").
%Module name: 1+.
%{error,{1,erl_parse,["syntax error before: ","'.'"]}}
%43> c(sixth).                
%sixth.erl:2: Warning: export_all flag enabled - all functions will be exported
%{ok,sixth}
%44> sixth:e 
%eval/0      eval_fun/1  eval_try/1  exit_fun/1  
%44> sixth:eval().
%Module name: lists.
%Function name: sum.
%0
%45> sixth:eval().
%Module name: 1+.  
%"Bad term"
%46> sixth:eval().
%Module name: "apple".
%Function name: apple.
%** exception error: bad argument
     %in function  apply/3
        %called as apply("apple",apple,[])
     %in call from sixth:eval/0 (sixth.erl, line 8)
%47> sixth:eval().
%Module name: liststssss.
%Function name: apple.
%** exception error: undefined function liststssss:apple/1
     %in function  sixth:eval/0 (sixth.erl, line 8)
%48> sixth:eval().
%Module name: lists.
%Function name: apple.
%** exception error: undefined function lists:apple/1
     %in function  sixth:eval/0 (sixth.erl, line 8)
%49> sixth:
%eval/0         eval_fun/1     eval_try/1     exit_fun/1     module_info/0  
%module_info/1  
%49> sixth:module_info().
%[{module,sixth},
 %{exports,[{eval,0},
           %{eval_try,1},
           %{exit_fun,1},
           %{eval_fun,1},
           %{module_info,0},
           %{module_info,1}]},
 %{attributes,[{vsn,[970969749882290366711687979762338526]}]},
 %{compile,[{options,[]},
           %{version,"7.1"},
           %{source,"/Users/melindatoth/Desktop/dds/sixth.erl"}]},
 %{native,false},
 %{md5,<<0,187,0,129,54,158,23,207,240,93,55,233,164,222,
        %74,222>>}]
%50> sixthsss:module_info().
%** exception error: undefined function sixthsss:module_info/0
%51> c(sixth).              
%sixth.erl:2: Warning: export_all flag enabled - all functions will be exported
%{ok,sixth}
%52> sixth:eval().          
%Module name: lsistssss.
%"Non existing module"
%53> sixthsss:module_info(export).
%** exception error: undefined function sixthsss:module_info/1
%54> sixthsss:module_info(exports).
%** exception error: undefined function sixthsss:module_info/1
%55> sixth:module_info(exports).   
%[{eval,0},
 %{eval_try,1},
 %{exit_fun,1},
 %{eval_fun,1},
 %{module_info,0},
 %{module_info,1}]
%56> List = sixth:module_info(exports).
%[{eval,0},
 %{eval_try,1},
 %{exit_fun,1},
 %{eval_fun,1},
 %{module_info,0},
 %{module_info,1}]
%57> lists:keyfind(eval, 1, List).
%{eval,0}
%58> lists:keyfind(0, 2, List).   
%{eval,0}
%59> lists:keyfind(1, 2, List).
%{eval_try,1}
%60> lists:keyfind(1, 2, [2,3]).
%false
%61> lists:keyfind(1, 2, [2,3, {apple, 1}]).
%{apple,1}
%62> lists:keyfind(eval, 1, List).          
%{eval,0}
%63> lists:keyfind(evaahjsgl, 1, List).
%false
%64> c(sixth).                              
%sixth.erl:2: Warning: export_all flag enabled - all functions will be exported
%sixth.erl:9: Warning: variable 'Arity' is unused
%{ok,sixth}
%65> sixth:eval().                          
%Module name: lists.
%Function name: apple.
%"Bad term"
%66> c(sixth).    
%sixth.erl:2: Warning: export_all flag enabled - all functions will be exported
%sixth.erl:9: Warning: variable 'Arity' is unused
%{ok,sixth}
%67> sixth:eval().
%Module name: lists.
%Function name: ejsjdk.
%"Non existing function"
%68> c(sixth).    
%sixth.erl:2: Warning: export_all flag enabled - all functions will be exported
%{ok,sixth}
%69> sixth:eval().
%Module name: lists.
%Function name: max.
%Give me an argument: [3,4].
%4
%70> sixth:eval().
%Module name: lists.
%Function name: nth.
%Give me an argument: 2.
%Give me an argument: [4,5,6].
%5
%71> sixth:eval().
%Module name: lists.
%Function name: nth.
%Give me an argument: ".
%Give me an argument: ".
%Give me an argument: ok.
%** exception error: no function clause matching lists:nth(".\n",ok) (lists.erl, line 170)
     %in function  sixth:eval/0 (sixth.erl, line 16)
%72> sixth:eval().
%Module name: lists.
%Function name: nth.
%Give me an argument: +.
%"Bad term"
%73> c(sixth).    
%sixth.erl:23: variable 'Arity' unsafe in 'try' (line 5)
%sixth.erl:23: variable 'Fun' unsafe in 'try' (line 5)
%sixth.erl:23: variable 'Mod' unsafe in 'try' (line 5)
%sixth.erl:2: Warning: export_all flag enabled - all functions will be exported
%error
%74> c(sixth).
%sixth.erl:33: variable 'Arity' unsafe in 'try' (line 15)
%sixth.erl:33: variable 'Fun' unsafe in 'try' (line 15)
%sixth.erl:33: variable 'Mod' unsafe in 'try' (line 15)
%sixth.erl:2: Warning: export_all flag enabled - all functions will be exported
%error
%75> c(sixth).
%sixth.erl:2: Warning: export_all flag enabled - all functions will be exported
%{ok,sixth}
%76> sixth:call([5,14,12]).
%[8,610,233]
%77> sixth:call([35,36, 37]).
%[14930352,24157817,39088169]
%78> spawn(lists, max, [[2,3]]).
%<0.197.0>
%79> c(sixth).                  
%sixth.erl:2: Warning: export_all flag enabled - all functions will be exported
%sixth.erl:18: Warning: variable 'X' is unused
%sixth.erl:18: Warning: variable 'X' shadowed in 'fun'
%{ok,sixth}
%80> sixth:call_par([34,35,36]).
%[<0.204.0>,<0.205.0>,<0.206.0>]
%81> 
%=ERROR REPORT==== 16-Oct-2018::10:03:35 ===
%Error in process <0.204.0> with exit value:
%{{badarity,{#Fun<sixth.5.92073998>,[]}},[{erlang,apply,2,[]}]}

%=ERROR REPORT==== 16-Oct-2018::10:03:35 ===
%Error in process <0.205.0> with exit value:
%{{badarity,{#Fun<sixth.5.92073998>,[]}},[{erlang,apply,2,[]}]}

%=ERROR REPORT==== 16-Oct-2018::10:03:35 ===
%Error in process <0.206.0> with exit value:
%{{badarity,{#Fun<sixth.5.92073998>,[]}},[{erlang,apply,2,[]}]}
%81> c(sixth).                  
%sixth.erl:2: Warning: export_all flag enabled - all functions will be exported
%{ok,sixth}
%82> sixth:call_par([34,35,36]).
%[<0.213.0>,<0.214.0>,<0.215.0>]
%83> flush().
%Shell got 9227465
%Shell got 14930352
%Shell got 24157817
%ok
%84> 
