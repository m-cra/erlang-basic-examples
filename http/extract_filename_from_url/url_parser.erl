%% url_parser:filename_from_uri("http://www.baidu.com/download/emessager.apk").

me_from_uri(Uri) when is_list(Uri) ->
  filename_from_uri(uri:from_string(Uri));

filename_from_uri(Uri) when is_record(Uri, uri) ->
  Path = Uri#uri.path,
  {match, [{Start, Len},_]} = re:run(Path, "([^/]+){1}"),
  string:substr(Path, Start+1, Len).
