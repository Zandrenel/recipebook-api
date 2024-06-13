% This module declaration is why other prolog files can import and make use of it
% the import name of the module is what's declared in the first parameter
% the list of predicates afterwards are whats exported, it won't export a predicate that isn't declared
:- module(mealplans, [
	      basic_handler/2,
	      basic_handler_post/2,
	      basic_handler_post/3,		      
	      low_calorie_handler/2
	  ]).
% libraries need to be declared after the module declaration for it to be used.
:- use_module(library(http/http_server)).
:- use_module(library(dcgs)).
:- use_module(library(pio)).
:- use_module(library(charsio)).
:- use_module(library(serialization/json)).
:- use_module(library(lists)).
:- use_module(library(pairs)).


% here are the predicates in the module that are exported
basic_handler(_Request, Response):-
    http_status_code(Response, 200),
    http_body(Response, text("Hello Basic!")).

low_calorie_handler(_Request, Response):-
    http_status_code(Response, 200),
    http_body(Response, text("Hello low!")).



% Here are some routes that test out POST requests
basic_handler_post(Basic, Request, Response):-
    http_status_code(Response, 200),
    % This its taking the body from the Request stream
    http_body(Request, text(Body)),
    % If its a valid JSON its converting it to JSON
    phrase(json_chars(pairs(Prolog_Body)), Body),
    % This gets a value based on if the KEY of the value matches
    % Basic which is a variable passed through the route params
    member(string(Basic)-string(Author),Prolog_Body),
    % Here the Value is unified with the text in the response.
    http_body(Response, text(Author)).

% here are the predicates in the module that are exported
basic_handler_post(Basic, _Request, Response):-
    http_status_code(Response, 200),
    % fail case that just returns the param as text
    http_body(Response, text(Basic)).

% no param case, returns the "author" value from the request object json always
basic_handler_post(Request, Response):-
    http_status_code(Response, 200),
    http_body(Request, text(Body)),
    phrase(json_chars(pairs(Prolog_Body)), Body),
    member(string("author")-string(Author),Prolog_Body),
    http_body(Response, text(Author)).
