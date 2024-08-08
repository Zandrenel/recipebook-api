% library declarations
:- use_module(library(http/http_server)).
%:- use_module(library(http/http_open)).

:- use_module(library(charsio)).

% self made module declarations
%% :- use_module(modules/mealplans).
%% :- use_module(modules/recipes).

% this is where the program runs, querying the server predicate
% will cause the program to start listening on the designated port
server(Port) :-
    http_listen(Port, [
		    % Here are  the declarations for every route
		    % the following is the format 
		    % REQUESTTYPE( +Route, +Predicate)
		    % every predicate is arity 2 minimum to take the request and response data
		    get(/, root_handler),
%		    get(test, root_handler2),
		    %% get(mealplan/basic, basic_handler),
		    %% % 2 cases of post request with a dynamic parameter
		    %% post(mealplan/basic/Basic, basic_handler_post(Basic)),
		    %% post(mealplan/Basic/basic, basic_handler_post(Basic)),
		    %% % basic post request that only takes  json body
		    %% post(mealplan/basic, basic_handler_post),
		    %% get(mealplan/low_calorie, low_calorie_handler),
		    %% get(recipes, recipe_handler_getAll),
		    %% get(recipe/recipe, recipe_handler),
		    %% post(recipe/recipe, recipe_handler),
		    options(_,preflight),
		    get(_,error_handler)		   
		]).

% base root handler for testing and demo purposes
root_handler(_Request, Response):-
    http_status_code(Response, 200),
    http_body(Response, text("Hello Root!")).

%% % base root handler for testing and demo purposes
%% root_handler2(_Request, Response):-
%%     write(1),
%%     test_get(HTML),
%%     write(5),
%%     http_body(Response, text(HTML)),
%%     write(6).

%% test_get(Text):-
%%     write(2),
%%     http_open("https://alexanderdelaurentiis.com", S, [method(get)]),
%%     write(3),
%%     get_n_chars(S, 10, Text),
%%     write(4).
%% % any route which doesn't exist that is attempted to be get queried will return this instead
error_handler(_Request, Response):-
    http_status_code(Response, 404),
    http_body(Response, text("Route Not Found")).

preflight(_Request, Response):-
    http_status_code(Response, 200),
    http_headers(Response, ["Access-Control-Allow-Origin"-"*",
			   "Access-Control-Allow-Headers"-"*"]),
    http_body(Response, text("Route Not Found")).
