:- module(recipes,
	  [
	      recipe_handler/2
	  ]).	      
% Library imports
:- use_module(library(http/http_server)).
:- use_module(library(charsio)).

% module imports of modules in the same directory
:- use_module(recipe_parser).

% here are the predicates in the module that are exported
recipe_handler(_Request, Response):-
    http_status_code(Response, 200),
    % Uses recipe definition to decide behavior, can potentially change the behavior based on if its a
    % local file, data base entry, or link to a recipe, etc. 
    recipe(local_file, 'chicken stir fry', File),
    % calls the predicate from the imported recipe_parser, name subject to change
    get_recipe_from_file(File, Recipe0),
    % writes the prolog term from a data structure to a character list, this allows it to be parsed as text
    % and hence returned through the get request as a text return.
    write_term_to_chars(Recipe0,[],Recipe),
    http_body(Response, text(Recipe)).

% file links vs aliases for each recipe, can by dynamically generated with the assert and retract predicates too
recipe(local_file, 'chicken stir fry', "./recipes/chicken_stir_fry.json").

