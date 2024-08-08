:- use_module(library(http/http_server)).
:- use_module(library(http/http_open)).
:- use_module(library(charsio)).

server(Port) :-
    http_listen(Port, [
                    get(/, root_handler),
		    get(test, root_handler2)
		]).

root_handler(Response, _Request):-
    write(1),
    http_status_code(Response, 200),
    write(2),
    http_body(Response, text("Hello!")),
    write(3).

root_handler2(Response, _Request):-
    write(1),
    test_get(HTML),
    write(5),
    http_body(Response, text(HTML)),
    write(6).

test_get(Text):-
    write(2),
    http_open("https://github.com/mthom/scryer-prolog", S, [method(get)]),
    write(3),
    get_n_chars(S, 10, Text),
    close(S),
    write(4).
