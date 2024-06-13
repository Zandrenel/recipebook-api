% Declares module and exports designated predicates
:- module(recipe_parser,
	  [
	      get_recipe_from_file/2
	  ]).	      

% Library Imports
:- use_module(library(dcgs)).
:- use_module(library(pio)).
:- use_module(library(serialization/json)).
:- use_module(library(charsio)).
:- use_module(library(lists)).

/**
 * Based on the file extension prolog will try to go to the next predicate until it can unify 
 * with a case that evaluates to true. We are checking the file extension first so that we can 
 * change the parsing or reading behavior based on it. Right now there is a generic fail case
 * and a basic case for jsons and txt files.
 */

% A case for json file extensions
get_recipe_from_file(File,Recipe):-
    phrase(file_extension(".json"),File),!,
    % Unifys the file contents to prolog data structures, if the file is a valid json it will succeed.
    phrase_from_file(json_chars(Recipe), File).

% A case for txt file extensions
get_recipe_from_file(File,Recipe):-    
    phrase(file_extension(".txt"),File),!,
    Recipe = recipe(Name, Author, Ingredients),
    phrase_from_file(name(Name),File),!,
    phrase_from_file(author(Author),File),!,
    findall(I,phrase_from_file(ingredient(I),File),Ingredients).

% Fail Case
get_recipe_from_file(_,'Recipe not Found').

% DCG to detect File Extensions, it will take a seqence of characters and if there exists a sequence from the
% end of the word up to a period that matches it will return true.
file_extension(['.'|EXT]) --> { \+ member('.',EXT) }, ... , ['.'], seq(EXT).
