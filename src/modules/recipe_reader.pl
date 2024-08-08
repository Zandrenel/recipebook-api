:- module(recipe_reader,
	  [
	      getAll_db/1
	  ]).
% Library Imports
:- use_module(library(dcgs)).
:- use_module(library(pio)).
:- use_module(library(serialization/json)).
:- use_module(library(charsio)).
:- use_module(library(lists)).
:- use_module(library(http/http_open)).
:- use_module(library(http/http_server)).



/**
http://localhost:6363/api/document/admin/recipes/?as_list=true
http:// ssl
localhost:6363 url
api/document base route
/admin team
/recipes collection
/?as_list=true options

*/



checkConnection_db(HTML):-
    chars_base64("admin:pass", Auth, []),
    append("Basic ", Auth, BasicAuth),
    http_open("http://localhost:6363/api/ok", S, [
		  request_headers(['Authorization'(BasicAuth)])
	      ]),
    get_n_chars(S, _N, HTML).



getAll_db(HTML):-
    write("s2"),nl,
    chars_base64("admin:pass", Auth, []),
    append("Basic ", Auth, BasicAuth),
    http_open("http://localhost:6363/api/document/admin/recipes/?as_list=true", S, [
		  request_headers(['Authorization'(BasicAuth)])
	      ]),
    write("s3"),nl,
    get_n_chars(S, _N, HTML).


test_insert(Response) :-
    R = "{ \"name\":\"polenta\", \"author\":\"Alexander De Laurentiis\", \"ingredients\":[{ \"name\":\"cornmeal\",\"quantity\":1, \"measurement\":\"cups\" },{ \"name\":\"water\",\"quantity\":4, \"measurement\":\"cups\" } ]}",
    insert_recipe(R, Response).



insert_recipe(Recipe,Response):-
    chars_base64("admin:pass", Auth, []),
    append("Basic ", Auth, BasicAuth),
    http_open("http://localhost:6363/api/document/admin/recipes/?author='Alexander De Laurentiis'&message='recipe inserted'", S, [
		  request_headers(['Authorization'(BasicAuth),
				   'Content-Type'("application/json")]),
		  method(post),
		  data(Recipe)
	      ]),
    get_n_chars(S, _N, HTML),
    http_body(Response, text(HTML)).

