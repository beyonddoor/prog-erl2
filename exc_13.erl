-module(exc_13).
-compile([export_all]).

my_spawn(Mod, Func, Args) ->
    Pid = spawn(Mod, Func, Args),
    % Now = timer:time(), % now()
    Start = os:timestamp(),
    lib_misc:on_exit(Pid, fun(Why)-> io:format("exit for ~p, time cost ~p~n", [Why, timer:now_diff(os:timestamp(), Start) / 1000]) end),
    Pid.
    
my_spawn(Mod, Func, Args, Time) -> 
    Pid = spawn(Mod, Func, Args),
    receive
    after Time ->
        exit(Pid, timeout)
    end.
    
demo_myspawn() ->
    _Pid = my_spawn(?MODULE, counter, [1, 10], 20),
    _Pid2 = my_spawn(?MODULE, counter, [1, 100]).
    
counter(From, To) ->
    lib_misc:for(From, To, fun(N) -> io:format("In For ~p~n", [N]) end),
    io:format("work finished~n").

