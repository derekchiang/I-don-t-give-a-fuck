-module (idgaf_main_controller, [Req]).
-compile (export_all).

-define (DEBUG, true).

-ifdef (DEBUG).
-define (SITE_URL, "http://localhost:8001/").
-define (PRINT (P), io:format("Debug:~n~p~n", [P])).
-else.
-define (SITE_URL, "http://www.idontgiveafuck.net/").
-endif.

generate_random_string() ->
    AllowedChars = "qwertyuiopasdfghjklzxcvbnm",
    Str = lists:foldl(fun(_, Acc) ->
                [lists:nth(random:uniform(length(AllowedChars)),
                        AllowedChars)]
                ++ Acc
        end, [], lists:seq(1, 10)),
    R = boss_db:find_first(link_to_names, [{link, 'equals', Str}]),
    if
        R =/= undefined -> generate_random_string();
        R =:= undefined -> Str
    end.

index('GET', []) ->
    {ok, []};

index('POST', []) -> 
    Name = Req:post_param("name"),
    if
        (Name =:= undefined) or (Name =:= "") ->
            {ok, [{name_not_provided, true}]};
        true ->
            RanString = generate_random_string(),
            Url = ?SITE_URL ++ "page?id=" ++ RanString,
            NewRecord = link_to_names:new(id, RanString, [Name]),
            NewRecord:save(),
            {ok, [{url, Url}, {name, Name}]}
    end.

page('GET', []) ->
    ?PRINT("WTF2"),
    PageId = Req:query_param("id"),
    Ltn = boss_db:find_first(link_to_names, [{link, 'equals', PageId}]),
    if
        Ltn =:= undefined ->
            {redirect, "/"};
        true ->
            Names = Ltn:names(),
            {ok, [{names, Names}]}
    end;

page('POST', []) ->
    ?PRINT("WTF"),
    PageId = Req:query_param("id"),
    Name = Req:post_param("name"),
    Ltn = boss_db:find_first(link_to_names, [{link, 'equals', PageId}]),
    if
        Ltn =:= undefined ->
            {redirect, "/"};
        true ->
            Names = Ltn:names(),
            if
                (Name =:= undefined) or (Name =:= "") ->
                    {ok, [{name_not_provided, true}, {names, Names}]};
                true ->
                    NewLtn = Ltn:set(names, [Name | Names]),
                    boss_db:save_record(NewLtn),
                    {ok, [{names, NewLtn:names()}]}
            end
    end.