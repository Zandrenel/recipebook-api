% This module declaration is why other prolog files can import and make use of it
% the import name of the module is what's declared in the first parameter
% the list of predicates afterwards are whats exported, it won't export a predicate that isn't declared
:- module(mealplans, [
	      basic_handler/2,
	      low_calorie_handler/2,
	      get_recipe_from_file/1
	  ]).
% libraries need to be declared after the module declaration for it to be used.
:- use_module(library(http/http_server)).
:- use_module(library(dcgs)).
:- use_module(library(pio)).

% here are the predicates in the module that are exported
basic_handler(_Request, Response):-
    http_status_code(Response, 200),
    get_recipe_from_file(Recipe),
    http_body(Response, text(Recipe)).

low_calorie_handler(_Request, Response):-
    http_status_code(Response, 200),
    http_body(Response, text("Hello low!")).


get_recipe_from_file(Recipe):-
    open('recipes/pesto_pasta.txt',read,S),
    phrase_from_stream(author(Author),S),
    Recipe = recipe(Author).


author(Author) --> "a:", seq(Author), ['\n'].

% ?- get_recipe_from_file(Recipe).
%@ caught: error(existence_error(procedure,phrase_from_stream/2),phrase_from_stream/2)

