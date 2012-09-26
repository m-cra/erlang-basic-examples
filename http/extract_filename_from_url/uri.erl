from_string(Uri) ->
	%{http,ELS}
    {Scheme, Uri1} = parse_scheme(Uri),
	
	%{www.xxx.com:port,ELS}
    {Authority, Uri2} = parse_authority(Uri1),
    
	%{[],"www.xxx.com:port"}
	{UserInfo, HostPort} = parse_user_info(Authority),
	
	%{www.xxx.com,port}
    {Host, Port} = parse_host_port(HostPort),
	
	%
    {Path, Uri3} = parse_path(Uri2),
    {Query, Uri4} = parse_query(Uri3),
    Frag = parse_frag(Uri4),
    new(Scheme, UserInfo, Host, Port, Path, Query, Frag, Uri).

%http
parse_scheme(Uri) ->
    parse_scheme(Uri, []).

parse_scheme([$: | Uri], Acc) ->
    {lists:reverse(Acc), Uri};
parse_scheme([], Acc) ->
    {[], lists:reverse(Acc)};
parse_scheme([C | Rest], Acc) ->
    parse_scheme(Rest, [C | Acc]).

parse_authority("//" ++ Uri) ->
    parse_authority(Uri, "");
parse_authority(Uri) ->
    Uri.

%www.xxx.com
parse_authority([$/ | Rest], Acc) ->
    {lists:reverse(Acc), [$/ | Rest]};
parse_authority([], Acc) ->
    {lists:reverse(Acc), []};
parse_authority([C | Rest], Acc) ->
    parse_authority(Rest, [C | Acc]).

parse_user_info(Authority) ->
    parse_user_info(Authority, []).

parse_user_info([$@ | HostPort], Acc) ->
    {lists:reverse(Acc), HostPort};
parse_user_info([], Acc) ->
    {[], lists:reverse(Acc)};
parse_user_info([C | HostPort], Acc) ->
    parse_user_info(HostPort, [C | Acc]).

parse_host_port(HostPort) ->
    case string:tokens(HostPort, ":") of
        [Host] -> {Host, ""};
        [Host, Port] -> {Host, list_to_integer(Port)};
        _ -> throw({uri_error, {invalid_host_port, HostPort}})
    end.

parse_path(Uri) ->
    parse_path(Uri, []).

parse_path([C | Uri], Acc) when C == $?; C == $# ->
    {lists:reverse(Acc), [C | Uri]};
parse_path([], Acc) ->
    {lists:reverse(Acc), ""};
parse_path([C | Uri], Acc) ->
    parse_path(Uri, [C | Acc]).

parse_query([$? | Uri]) ->
    parse_query(Uri, []);
parse_query(Uri) ->
    {"", Uri}.

parse_query([$# | Uri], Acc) ->
    {lists:reverse(Acc), [$# | Uri]};
parse_query([], Acc) ->
    {lists:reverse(Acc), ""};
parse_query([C | Rest], Acc) ->
    parse_query(Rest, [C | Acc]).

parse_frag([$# | Frag]) ->
    unquote(Frag);
parse_frag("") ->
    "";
parse_frag(Data) ->
    throw({uri_error, {data_left_after_parsing, Data}}).

new(Scheme, UserInfo, Host, Port, Path, Query, Frag, Uri) ->
    update_raw(#uri{scheme = Scheme,
                    user_info = unquote(UserInfo),
                    host = Host,
                    port = Port,
                    path = unquote(Path),
                    raw_query = Query,
                    frag = unquote(Frag),
                    raw = Uri}).

new(Scheme, UserInfo, Host, Port, Path, Query, Frag) ->
    update_raw(#uri{scheme = Scheme,
                    user_info = unquote(UserInfo),
                    host = Host,
                    port = Port,
                    path = unquote(Path),
                    raw_query = Query,
                    frag = unquote(Frag)}).

update_raw(Uri) ->
    Uri#uri{raw = iolist_to_string(to_iolist(Uri))}.

iolist_to_string(Str) ->
    binary_to_list(iolist_to_binary(Str)).

unquote(Str) ->
    unquote(Str, []).

unquote([], Acc) ->
    lists:reverse(Acc);
unquote([$+ | Str], Acc) ->
    unquote(Str, [$  | Acc]);
unquote([$\%, A, B | Str], Acc) ->
    unquote(Str, [erlang:list_to_integer([A, B], 16) | Acc]);
unquote([C | Str], Acc) ->
    unquote(Str, [C | Acc]).
