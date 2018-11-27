-module(fourth).

-compile(export_all).

count3(List) ->
	count_map(List, #{}).
	
count_map([], Map) ->
	Map;
count_map([H|T], Map) ->
	case Map of
		#{H:=V} -> count_map(T, Map#{H=>V+1});
		_ -> count_map(T, Map#{H=>1})
	end.

count2(List) ->
	count_helper(List, []).
	
count_helper([], _) ->
	[];
count_helper([H|T], Helper) ->
	case lists:member(H, Helper) of
		true -> count_helper(T, Helper);
		_ -> [{H, third:count(H, T)+1} | count_helper(T,[H | Helper])]
	end.
	 
%count_helper([H|T], Helper) when lists:member(H, Helper) ->
	%count_helper(T, Helper);
%count_helper([H|T], Helper) ->
	%[{H, third:count(H, T)+1} | count_helper(T, [H | Helper])].

count([]) ->
	[];
count([H|T]) ->
	[{H, third:count(H, T)+1} | count(T)].

%count([H|T] = L) ->
%	[{H, third:count(H, L)} | count(T)].

%Last login: Mon Oct  1 08:29:09 on ttys001
%melindas-mbp:fp2 melindatoth$ pwd
%/Users/melindatoth/Desktop/fp2
%melindas-mbp:fp2 melindatoth$ cd ..
%melindas-mbp:Desktop melindatoth$ cd dds
%melindas-mbp:dds melindatoth$ erl
%Erlang/OTP 20 [erts-9.0] [source] [64-bit] [smp:4:4] [ds:4:4:10] [async-threads:10] [hipe] [kernel-poll:false] [dtrace]

%Hello Melinda
%Eshell V9.0  (abort with ^G)
%1> code:get_path().     
%["/Users/melindatoth/Desktop",".",
 %"/usr/local/Cellar/erlang/20.0/lib/erlang/lib/kernel-5.3/ebin",
 %"/usr/local/Cellar/erlang/20.0/lib/erlang/lib/stdlib-3.4/ebin",
 %"/usr/local/Cellar/erlang/20.0/lib/erlang/lib/yaws-2.0.4/ebin",
 %"/usr/local/Cellar/erlang/20.0/lib/erlang/lib/xmerl-1.3.15/ebin",
 %"/usr/local/Cellar/erlang/20.0/lib/erlang/lib/wx-1.8.1/ebin",
 %"/usr/local/Cellar/erlang/20.0/lib/erlang/lib/tools-2.10/ebin",
 %"/usr/local/Cellar/erlang/20.0/lib/erlang/lib/syntax_tools-2.1.2/ebin",
 %"/usr/local/Cellar/erlang/20.0/lib/erlang/lib/ssl-8.2/ebin",
 %"/usr/local/Cellar/erlang/20.0/lib/erlang/lib/ssh-4.5/ebin",
 %"/usr/local/Cellar/erlang/20.0/lib/erlang/lib/snmp-5.2.6/ebin",
 %"/usr/local/Cellar/erlang/20.0/lib/erlang/lib/sasl-3.0.4/ebin",
 %"/usr/local/Cellar/erlang/20.0/lib/erlang/lib/runtime_tools-1.12/ebin",
 %"/usr/local/Cellar/erlang/20.0/lib/erlang/lib/reltool-0.7.4/ebin",
 %"/usr/local/Cellar/erlang/20.0/lib/erlang/lib/public_key-1.4.1/ebin",
 %"/usr/local/Cellar/erlang/20.0/lib/erlang/lib/parsetools-2.1.5/ebin",
 %"/usr/local/Cellar/erlang/20.0/lib/erlang/lib/otp_mibs-1.1.1/ebin",
 %"/usr/local/Cellar/erlang/20.0/lib/erlang/lib/os_mon-2.4.2/ebin",
 %"/usr/local/Cellar/erlang/20.0/lib/erlang/lib/orber-3.8.3/ebin",
 %"/usr/local/Cellar/erlang/20.0/lib/erlang/lib/observer-2.4/ebin",
 %"/usr/local/Cellar/erlang/20.0/lib/erlang/lib/mnesia-4.15/ebin",
 %"/usr/local/Cellar/erlang/20.0/lib/erlang/lib/megaco-3.18.2/ebin",
 %"/usr/local/Cellar/erlang/20.0/lib/erlang/lib/inets-6.4/ebin",
 %"/usr/local/Cellar/erlang/20.0/lib/erlang/lib/ic-4.4.2/ebin",
 %"/usr/local/Cellar/erlang/20.0/lib/erlang/lib/hipe-3.16/ebin",
 %"/usr/local/Cellar/erlang/20.0/lib/erlang/lib/eunit-2.3.3/ebin",
 %"/usr/local/Cellar/erlang/20.0/lib/erlang/lib/et-1.6/ebin",
 %[...]|...]
%2> code
%code           code_server    
%2> code:add_patha("/Users/melindatoth").
%true
%3> code:get_path().                     
%["/Users/melindatoth","/Users/melindatoth/Desktop",".",
 %"/usr/local/Cellar/erlang/20.0/lib/erlang/lib/kernel-5.3/ebin",
 %"/usr/local/Cellar/erlang/20.0/lib/erlang/lib/stdlib-3.4/ebin",
 %"/usr/local/Cellar/erlang/20.0/lib/erlang/lib/yaws-2.0.4/ebin",
 %"/usr/local/Cellar/erlang/20.0/lib/erlang/lib/xmerl-1.3.15/ebin",
 %"/usr/local/Cellar/erlang/20.0/lib/erlang/lib/wx-1.8.1/ebin",
 %"/usr/local/Cellar/erlang/20.0/lib/erlang/lib/tools-2.10/ebin",
 %"/usr/local/Cellar/erlang/20.0/lib/erlang/lib/syntax_tools-2.1.2/ebin",
 %"/usr/local/Cellar/erlang/20.0/lib/erlang/lib/ssl-8.2/ebin",
 %"/usr/local/Cellar/erlang/20.0/lib/erlang/lib/ssh-4.5/ebin",
 %"/usr/local/Cellar/erlang/20.0/lib/erlang/lib/snmp-5.2.6/ebin",
 %"/usr/local/Cellar/erlang/20.0/lib/erlang/lib/sasl-3.0.4/ebin",
 %"/usr/local/Cellar/erlang/20.0/lib/erlang/lib/runtime_tools-1.12/ebin",
 %"/usr/local/Cellar/erlang/20.0/lib/erlang/lib/reltool-0.7.4/ebin",
 %"/usr/local/Cellar/erlang/20.0/lib/erlang/lib/public_key-1.4.1/ebin",
 %"/usr/local/Cellar/erlang/20.0/lib/erlang/lib/parsetools-2.1.5/ebin",
 %"/usr/local/Cellar/erlang/20.0/lib/erlang/lib/otp_mibs-1.1.1/ebin", 
 %"/usr/local/Cellar/erlang/20.0/lib/erlang/lib/os_mon-2.4.2/ebin",
 %"/usr/local/Cellar/erlang/20.0/lib/erlang/lib/orber-3.8.3/ebin",
 %"/usr/local/Cellar/erlang/20.0/lib/erlang/lib/observer-2.4/ebin",
 %"/usr/local/Cellar/erlang/20.0/lib/erlang/lib/mnesia-4.15/ebin",
 %"/usr/local/Cellar/erlang/20.0/lib/erlang/lib/megaco-3.18.2/ebin",
 %"/usr/local/Cellar/erlang/20.0/lib/erlang/lib/inets-6.4/ebin",
 %"/usr/local/Cellar/erlang/20.0/lib/erlang/lib/ic-4.4.2/ebin",
 %"/usr/local/Cellar/erlang/20.0/lib/erlang/lib/hipe-3.16/ebin",
 %"/usr/local/Cellar/erlang/20.0/lib/erlang/lib/eunit-2.3.3/ebin",
 %[...]|...]
%4> q().
%ok
%5> melindas-mbp:dds melindatoth$ erl
%Erlang/OTP 20 [erts-9.0] [source] [64-bit] [smp:4:4] [ds:4:4:10] [async-threads:10] [hipe] [kernel-poll:false] [dtrace]

%Hello Melinda
%Eshell V9.0  (abort with ^G)
%1> code:get_path().
%["/Users/melindatoth/Desktop",".",
 %"/usr/local/Cellar/erlang/20.0/lib/erlang/lib/kernel-5.3/ebin",
 %"/usr/local/Cellar/erlang/20.0/lib/erlang/lib/stdlib-3.4/ebin",
 %"/usr/local/Cellar/erlang/20.0/lib/erlang/lib/yaws-2.0.4/ebin",
 %"/usr/local/Cellar/erlang/20.0/lib/erlang/lib/xmerl-1.3.15/ebin",
 %"/usr/local/Cellar/erlang/20.0/lib/erlang/lib/wx-1.8.1/ebin",
 %"/usr/local/Cellar/erlang/20.0/lib/erlang/lib/tools-2.10/ebin",
 %"/usr/local/Cellar/erlang/20.0/lib/erlang/lib/syntax_tools-2.1.2/ebin",
 %"/usr/local/Cellar/erlang/20.0/lib/erlang/lib/ssl-8.2/ebin",
 %"/usr/local/Cellar/erlang/20.0/lib/erlang/lib/ssh-4.5/ebin",
 %"/usr/local/Cellar/erlang/20.0/lib/erlang/lib/snmp-5.2.6/ebin",
 %"/usr/local/Cellar/erlang/20.0/lib/erlang/lib/sasl-3.0.4/ebin",
 %"/usr/local/Cellar/erlang/20.0/lib/erlang/lib/runtime_tools-1.12/ebin",
 %"/usr/local/Cellar/erlang/20.0/lib/erlang/lib/reltool-0.7.4/ebin",
 %"/usr/local/Cellar/erlang/20.0/lib/erlang/lib/public_key-1.4.1/ebin",
 %"/usr/local/Cellar/erlang/20.0/lib/erlang/lib/parsetools-2.1.5/ebin",
 %"/usr/local/Cellar/erlang/20.0/lib/erlang/lib/otp_mibs-1.1.1/ebin", 
 %"/usr/local/Cellar/erlang/20.0/lib/erlang/lib/os_mon-2.4.2/ebin",
 %"/usr/local/Cellar/erlang/20.0/lib/erlang/lib/orber-3.8.3/ebin",
 %"/usr/local/Cellar/erlang/20.0/lib/erlang/lib/observer-2.4/ebin",
 %"/usr/local/Cellar/erlang/20.0/lib/erlang/lib/mnesia-4.15/ebin",
 %"/usr/local/Cellar/erlang/20.0/lib/erlang/lib/megaco-3.18.2/ebin",
 %"/usr/local/Cellar/erlang/20.0/lib/erlang/lib/inets-6.4/ebin",
 %"/usr/local/Cellar/erlang/20.0/lib/erlang/lib/ic-4.4.2/ebin",
 %"/usr/local/Cellar/erlang/20.0/lib/erlang/lib/hipe-3.16/ebin",
 %"/usr/local/Cellar/erlang/20.0/lib/erlang/lib/eunit-2.3.3/ebin",
 %"/usr/local/Cellar/erlang/20.0/lib/erlang/lib/et-1.6/ebin",
 %[...]|...]
%2> q().
%ok
%3> melindas-mbp:dds melindatoth$ 
%melindas-mbp:dds melindatoth$ 
%melindas-mbp:dds melindatoth$ erl
%Erlang/OTP 20 [erts-9.0] [source] [64-bit] [smp:4:4] [ds:4:4:10] [async-threads:10] [hipe] [kernel-poll:false] [dtrace]

%Hello Melinda
%Eshell V9.0  (abort with ^G)
%1> q().
%ok
%2> q().melindas-mbp:dds melindatoth$ erl
%Erlang/OTP 20 [erts-9.0] [source] [64-bit] [smp:4:4] [ds:4:4:10] [async-threads:10] [hipe] [kernel-poll:false] [dtrace]

%Hello Melinda

%=ERROR REPORT==== 2-Oct-2018::09:01:51 ===
%file:path_eval([".","/Users/melindatoth"],".erlang"): error on line 4: 4: evaluation failed with reason error:badarith and stacktrace [{erlang,'/',[1,0],[]},{erl_eval,do_apply,6,[{file,[101,114,108,95,101,118,97,108,46,101,114,108]},{line,670}]},{file,eval_stream2,6,[{file,[102,105,108,101,46,101,114,108]},{line,1397}]},{file,path_eval,3,[{file,[102,105,108,101,46,101,114,108]},{line,1066}]},{c,f_p_e,2,[{file,[99,46,101,114,108]},{line,689}]},{init,eval_script,2,[]},{init,do_boot,3,[]}]
%Eshell V9.0  (abort with ^G)
%1> q().
%ok
%2> q().melindas-mbp:dds melindatoth$ erl
%Erlang/OTP 20 [erts-9.0] [source] [64-bit] [smp:4:4] [ds:4:4:10] [async-threads:10] [hipe] [kernel-poll:false] [dtrace]

%Hello Melinda

%=ERROR REPORT==== 2-Oct-2018::09:07:18 ===
%file:path_eval([".","/Users/melindatoth"],".erlang"): error on line 5: 5: evaluation failed with reason error:undef and stacktrace [{erl_eval,cd,1,[]},{erl_eval,expr,3,[]}]
%Eshell V9.0  (abort with ^G)
%1> q().
%ok
%2> cd
%melindas-mbp:dds melindatoth$ 
%melindas-mbp:dds melindatoth$ pwd
%/Users/melindatoth/Desktop/dds
%melindas-mbp:dds melindatoth$ cd
%melindas-mbp:~ melindatoth$ pwd
%/Users/melindatoth
%melindas-mbp:~ melindatoth$ erl
%Erlang/OTP 20 [erts-9.0] [source] [64-bit] [smp:4:4] [ds:4:4:10] [async-threads:10] [hipe] [kernel-poll:false] [dtrace]

%Hello Melinda
%/Users/melindatoth/Desktop/dds
%Eshell V9.0  (abort with ^G)
%1> pwd().
%/Users/melindatoth/Desktop/dds
%ok
%2> c(fourth).
%fourth.erl:3: Warning: export_all flag enabled - all functions will be exported
%{ok,fourth}
%3> fourth:count([2,3,41,2]).
%** exception error: undefined function third:count/2
     %in function  fourth:count/1 (fourth.erl, line 8)
%4> ls().
%first.beam                        first.erl                          
%fourth.beam                       fourth.erl                         
%second.beam                       second.erl                         
%third.erl                         third.erl.bak.20180925-110709      

%ok
%5> c(third).                
%third.erl:2: Warning: export_all flag enabled - all functions will be exported
%{ok,third}
%6> ls().                    
%first.beam                        first.erl                          
%fourth.beam                       fourth.erl                         
%second.beam                       second.erl                         
%third.beam                        third.erl                          
%third.erl.bak.20180925-110709     
%ok
%7> fourth:count([2,3,41,2]).
%[{2,2},{3,1},{41,1},{2,1}]
%8> c(fourth).               
%fourth.erl:10: illegal guard expression
%fourth.erl:3: Warning: export_all flag enabled - all functions will be exported
%fourth.erl:10: Warning: variable 'H' is unused
%error
%9> c(fourth).               
%fourth.erl:3: Warning: export_all flag enabled - all functions will be exported
%{ok,fourth}
%10> fourth:count([2,3,41,2]).
%[{2,2},{3,1},{41,1},{2,1}]
%11> fourth:count2([2,3,41,2]).
%[]
%12> c(fourth).                
%fourth.erl:3: Warning: export_all flag enabled - all functions will be exported
%{ok,fourth}
%13> fourth:count2([2,3,41,2]).
%[{2,2},{3,1},{41,1}]
%14> fourth:count([2,3,41,2]). 
%[{2,2},{3,1},{41,1},{2,1}]
%15> Map = #{apple => 2}.
%#{apple => 2}
%16> #{apple:= V} = Map .
%#{apple => 2}
%17> V.  
%2
%18> Map#{apple=>V+1}.
%#{apple => 3}
%19> c(fourth).                
%fourth.erl:3: Warning: export_all flag enabled - all functions will be exported
%fourth.erl:10: Warning: variable 'T' is unused
%{ok,fourth}
%20> c(fourth).
%fourth.erl:3: Warning: export_all flag enabled - all functions will be exported
%{ok,fourth}
%21> fourth:count([2,3,41,2]).
%[{2,2},{3,1},{41,1},{2,1}]
%22> fourth:count3([2,3,41,2]).
%#{2 => 2,3 => 1,41 => 1}
%23> 
