% library declarations
:- use_module(library(http/http_server)).

% self made module declarations
:- use_module(modules/mealplans).
:- use_module(modules/recipes).

% this is where the program runs, querying the server predicate
% will cause the program to start listening on the designated port
server(Port) :-
    http_listen(Port, [
		    % Here are  the declarations for every route
		    % the following is the format 
		    % REQUESTTYPE( +Route, +Predicate)
		    % every predicate is arity 2 minimum to take the request and response data
		    get(/, root_handler),
		    get(mealplan/basic, basic_handler),
		    get(mealplan/low_calorie, low_calorie_handler),
		    get(recipe/recipe, recipe_handler),
		    post(recipe/recipe, recipe_handler),
		    get(_,error_handler)		   
		]).

% base root handler for testing and demo purposes
root_handler(_Request, Response):-
    http_status_code(Response, 200),
    http_body(Response, text("Hello Root!")).

% any route which doesn't exist that is attempted to be get queried will return this instead
error_handler(_Request, Response):-
    http_status_code(Response, 404),
    http_body(Response, text("Route Not Found")).
