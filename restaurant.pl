%  Restaurant Recommendation System for Surat  (GTU, AI 3170716)
%  Console expert system in SWI-Prolog.
%
%  Run:     swipl restaurant.pl      then      ?- start.
%  Reload:  ?- make.
%  Demo:    ?- run_samples.           Tests:  ?- run_tests.

:- use_module(library(lists)).
:- use_module(library(apply)).
:- use_module(library(readutil)).
:- use_module(library(aggregate)).
:- use_module(library(plunit)).

% Data file (not modified):
%   restaurant(Id, Name, Area, PrimaryCuisine, CostForTwoINR, VegType, AvgRating)
%   cuisine_tag(Id, Tag)      confidence(Id, Level)
:- include('surat_restaurants.pl').


% ============================================================
% SECTION 1: KNOWLEDGE REPRESENTATION (CO2)
% Rules built on top of the facts. Thresholds are facts so they
% are easy to change.
% ============================================================

% ---- Configurable thresholds -------------------------------

% budget_limit(Category, MaxCost): upper cost-for-two of a category.
% 'premium' is everything above the 'mid' limit.
budget_limit(budget, 600).
budget_limit(mid,    1200).

% rating_band(Category, MinRating): checked in this order, first match wins.
rating_band(excellent, 4.5).
rating_band(very_good, 4.0).
rating_band(good,      3.5).
rating_band(average,   0.0).

% related_cuisine(Cuisine, Near): used only by the "nearest cuisine" relaxation.
related_cuisine(chinese,       asian).
related_cuisine(chinese,       oriental).
related_cuisine(chinese,       pan_asian).
related_cuisine(chinese,       indo_chinese).
related_cuisine(asian,         chinese).
related_cuisine(asian,         oriental).
related_cuisine(asian,         pan_asian).
related_cuisine(asian,         sushi).
related_cuisine(sushi,         asian).
related_cuisine(sushi,         pan_asian).
related_cuisine(sushi,         japanese).
related_cuisine(italian,       pizza).
related_cuisine(italian,       pasta).
related_cuisine(italian,       continental).
related_cuisine(mexican,       continental).
related_cuisine(mexican,       fast_food).
related_cuisine(north_indian,  punjabi).
related_cuisine(north_indian,  mughlai).
related_cuisine(north_indian,  indian).
related_cuisine(south_indian,  indian).
related_cuisine(south_indian,  fast_food).
related_cuisine(gujarati,      thali).
related_cuisine(gujarati,      indian).
related_cuisine(gujarati,      north_indian).
related_cuisine(street_food,   fast_food).
related_cuisine(street_food,   rolls).
related_cuisine(cafe,          coffee).
related_cuisine(cafe,          bakery_dessert).
related_cuisine(bakery_dessert, cafe).
related_cuisine(bakery_dessert, desserts).
related_cuisine(bbq,           kebab).
related_cuisine(bbq,           buffet).
related_cuisine(multicuisine,  continental).
related_cuisine(multicuisine,  indian).

% ---- Basic rules -------------------------------------------

%! matches_cuisine(?Id, ?Cuisine) is nondet.
%  True if Cuisine is the primary cuisine of Id or one of its cuisine tags.
matches_cuisine(Id, Cuisine) :-
    restaurant(Id, _, _, Cuisine, _, _, _).
matches_cuisine(Id, Cuisine) :-
    cuisine_tag(Id, Cuisine).

%! primary_cuisine(?Id, ?Cuisine) is nondet.
%  Cuisine is the primary cuisine of Id.
primary_cuisine(Id, Cuisine) :-
    restaurant(Id, _, _, Cuisine, _, _, _).

%! within_budget(?Id, +MaxBudget) is semidet.
%  Cost for two of Id is =< MaxBudget.
within_budget(Id, MaxBudget) :-
    restaurant(Id, _, _, _, Cost, _, _),
    Cost =< MaxBudget.

%! in_area(?Id, ?Area) is nondet.
%  Id is located in Area.
in_area(Id, Area) :-
    restaurant(Id, _, Area, _, _, _, _).

%! veg_ok(?Id, +Pref) is semidet.
%  Pref 'veg' accepts veg and 'both' restaurants (a 'both' place serves veg food),
%  never 'nonveg'. Pref 'nonveg' or 'any' accepts every restaurant.
veg_ok(Id, veg) :-
    restaurant(Id, _, _, _, _, Type, _),
    memberchk(Type, [veg, both]).
veg_ok(Id, nonveg) :-
    restaurant(Id, _, _, _, _, _, _).
veg_ok(Id, any) :-
    restaurant(Id, _, _, _, _, _, _).

%! good_rating(?Id, +MinRating) is semidet.
%  AvgRating of Id is >= MinRating.
good_rating(Id, MinRating) :-
    restaurant(Id, _, _, _, _, _, Rating),
    Rating >= MinRating.

%! budget_category(?Id, ?Category) is det.
%  Category is budget / mid / premium according to the budget_limit/2 facts.
budget_category(Id, Category) :-
    restaurant(Id, _, _, _, Cost, _, _),
    budget_limit(budget, B),
    budget_limit(mid, M),
    (   Cost =< B -> Category = budget
    ;   Cost =< M -> Category = mid
    ;   Category = premium
    ).

%! rating_category(?Id, ?Category) is det.
%  Category is excellent / very_good / good / average (see rating_band/2).
rating_category(Id, Category) :-
    restaurant(Id, _, _, _, _, _, Rating),
    once(( rating_band(Category, Min), Rating >= Min )).


% ============================================================
% SECTION 2: SEARCH (CO1)
% Preferences are a term  prefs(Cuisine, Area, Budget, Veg, MinRating)
% where every argument may be the atom 'any'.
% During relaxation Cuisine may become near(Cuisine).
%
% Why this is depth-first search with backtracking:
%   State : a partially filled choice (a restaurant picked, constraints
%           checked one after another).
%   Goal  : a restaurant that satisfies ALL the constraints.
%   Prolog picks the next restaurant fact (depth-first, top to bottom);
%   as soon as one constraint fails it backtracks to the next fact.
%   findall/3 forces backtracking until every solution is collected.
% Time complexity: O(n) per query, n = number of restaurants (100),
%   as each restaurant is tried once with a constant number of checks.
% ============================================================

%! satisfies(?Id, +Prefs) is nondet.
%  Id is a restaurant meeting every constraint in Prefs (DFS + backtracking).
satisfies(Id, prefs(Cuisine, Area, Budget, Veg, MinRating)) :-
    restaurant(Id, _, _, _, _, _, _),       % choose a candidate
    cuisine_ok(Id, Cuisine),                % each check may fail -> backtrack
    area_ok(Id, Area),
    budget_ok(Id, Budget),
    veg_ok(Id, Veg),
    rating_ok(Id, MinRating).

%! cuisine_ok(+Id, +Cuisine) is semidet.
%  Cuisine constraint ('any', near(C) or a cuisine name).
cuisine_ok(_, any).
cuisine_ok(Id, near(C)) :-
    (   matches_cuisine(Id, C)
    ;   related_cuisine(C, Near), matches_cuisine(Id, Near)
    ), !.
cuisine_ok(Id, C) :-
    C \== any,
    C \= near(_),
    matches_cuisine(Id, C), !.

%! area_ok(+Id, +Area) is semidet.
area_ok(_, any).
area_ok(Id, Area) :- Area \== any, in_area(Id, Area).

%! budget_ok(+Id, +Budget) is semidet.
budget_ok(_, any).
budget_ok(Id, Budget) :- Budget \== any, within_budget(Id, Budget).

%! rating_ok(+Id, +MinRating) is semidet.
rating_ok(_, any).
rating_ok(Id, Min) :- Min \== any, good_rating(Id, Min).

%! find_matches(+Prefs, -Ids) is det.
%  Ids = all restaurants satisfying Prefs (collected with findall/3).
find_matches(Prefs, Ids) :-
    findall(Id, satisfies(Id, Prefs), Ids).

%! relax_step(+N, -Name, +Prefs0, -Prefs) is det.
%  Relaxation step N: 1 rating, 2 area, 3 budget +20%, 4 nearest cuisine.
relax_step(1, 'minimum rating', prefs(C, A, B, V, _), prefs(C, A, B, V, any)).
relax_step(2, 'area',           prefs(C, _, B, V, R), prefs(C, any, B, V, R)).
relax_step(3, 'budget (+20%)',  prefs(C, A, B0, V, R), prefs(C, A, B, V, R)) :-
    (   number(B0) -> B is B0 * 1.2 ; B = B0 ).
relax_step(4, 'cuisine (nearest match)', prefs(C0, A, B, V, R), prefs(C, A, B, V, R)) :-
    (   C0 = near(_) -> C = C0
    ;   C0 == any    -> C = any
    ;   C = near(C0)
    ).

%! recommend(+Prefs, -Ids, -Relaxed) is det.
%  Ids = matches; Relaxed = names of constraints relaxed ([] if none needed).
%  Constraints are relaxed one more at each step, in the order above,
%  until something matches. Steps that change nothing are skipped.
recommend(Prefs, Ids, Relaxed) :-
    find_matches(Prefs, Ids0),
    (   Ids0 \== []
    ->  Ids = Ids0, Relaxed = []
    ;   relax_from(1, Prefs, [], Ids, Relaxed)
    ).

%! relax_from(+N, +Prefs, +Done, -Ids, -Relaxed) is det.
%  Try relaxation steps N..4 cumulatively.
relax_from(N, _, Done, [], Done) :-
    N > 4, !.
relax_from(N, P0, Done, Ids, Relaxed) :-
    relax_step(N, Name, P0, P1),
    N1 is N + 1,
    (   P1 == P0
    ->  relax_from(N1, P0, Done, Ids, Relaxed)      % nothing to relax here
    ;   append(Done, [Name], Done1),
        find_matches(P1, Ids0),
        (   Ids0 \== []
        ->  Ids = Ids0, Relaxed = Done1
        ;   relax_from(N1, P1, Done1, Ids, Relaxed)
        )
    ).


% ============================================================
% SECTION 3: SCORING AND RANKING
% Score out of 100 = sum of five weighted parts (weights are facts).
% ============================================================

weight(rating,     40).
weight(budget,     25).
weight(cuisine,    20).
weight(area,       10).
weight(confidence,  5).

% confidence_points(Level, Points): points out of the 'confidence' weight.
confidence_points(high,   5).
confidence_points(medium, 3).
confidence_points(low,    1).

% Budget fit: cost/budget below this ratio is "too cheap" and gets 'cheap_factor'.
sweet_spot_ratio(0.4).
cheap_factor(0.6).
top_n(5).        % how many ranked results to show

%! score_parts(+Id, +Prefs, -Parts) is det.
%  Parts = [rating-P1, budget-P2, cuisine-P3, area-P4, confidence-P5].
score_parts(Id, prefs(Cuisine, Area, Budget, _, _), Parts) :-
    restaurant(Id, _, RArea, _, Cost, _, Rating),
    confidence(Id, Level),
    weight(rating, WR),  weight(budget, WB), weight(cuisine, WC),
    weight(area, WA),    weight(confidence, WF),
    PR is Rating / 5 * WR,
    budget_factor(Cost, Budget, FB), PB is FB * WB,
    cuisine_factor(Id, Cuisine, FC), PC is FC * WC,
    (   ( Area == any ; Area == RArea ) -> PA = WA ; PA = 0 ),
    confidence_points(Level, CP), PF is CP * WF / 5,
    Parts = [rating-PR, budget-PB, cuisine-PC, area-PA, confidence-PF].

%! budget_factor(+Cost, +Budget, -Factor) is det.
%  1.0 = ideal. Cheaper is better, but far below budget is slightly penalised;
%  at the budget limit the factor is 0.5; over budget (relaxed) it is 0.2.
budget_factor(_, any, 1.0) :- !.
budget_factor(Cost, Budget, Factor) :-
    Ratio is Cost / Budget,
    sweet_spot_ratio(Sweet),
    cheap_factor(Cheap),
    (   Ratio < Sweet -> Factor = Cheap
    ;   Ratio =< 1    -> Factor is 1 - (Ratio - Sweet) / (1 - Sweet) * 0.5
    ;   Factor = 0.2
    ).

%! cuisine_factor(+Id, +Cuisine, -Factor) is det.
%  1.0 primary cuisine (or 'any'), 0.5 tag only, 0 otherwise.
cuisine_factor(_, any, 1.0) :- !.
cuisine_factor(Id, near(C), F) :- !, cuisine_factor(Id, C, F).
cuisine_factor(Id, C, 1.0) :- primary_cuisine(Id, C), !.
cuisine_factor(Id, C, 0.5) :- matches_cuisine(Id, C), !.
cuisine_factor(_, _, 0.0).

%! score(+Id, +Prefs, -Score) is det.
%  Total score out of 100, rounded to 1 decimal.
score(Id, Prefs, Score) :-
    score_parts(Id, Prefs, Parts),
    findall(P, member(_-P, Parts), Ps),
    sum_list(Ps, Total),
    Score is round(Total * 10) / 10.

%! rank_by_score(+Prefs, +Ids, -Sorted) is det.
%  Sort Ids by score descending; ties by AvgRating (desc) then name.
rank_by_score(Prefs, Ids, Sorted) :-
    findall(k(NegS, NegR, Name, Id)-Id,
            ( member(Id, Ids),
              score(Id, Prefs, S), NegS is -S,
              restaurant(Id, Name, _, _, _, _, R), NegR is -R ),
            Keyed),
    keysort(Keyed, SortedKeyed),
    pairs_values(SortedKeyed, Sorted).

%! rank_by_rating(+Ids, -Sorted) is det.
%  Sort Ids by AvgRating descending, ties by name.
rank_by_rating(Ids, Sorted) :-
    findall(k(NegR, Name, Id)-Id,
            ( member(Id, Ids),
              restaurant(Id, Name, _, _, _, _, R), NegR is -R ),
            Keyed),
    keysort(Keyed, SortedKeyed),
    pairs_values(SortedKeyed, Sorted).

%! take(+N, +List, -Prefix) is det.
%  First N elements of List (or all of it if shorter).
take(N, List, Prefix) :-
    length(List, Len),
    M is min(N, Len),
    length(Prefix, M),
    append(Prefix, _, List), !.


% ============================================================
% SECTION 4: OUTPUT (tables and explanations)
% ============================================================

%! print_table(+Ids, +Prefs) is det.
%  Aligned table, one row per Id, in the given order.
print_table(Ids, Prefs) :-
    format("~t~w~4+ ~w~t~37+ ~w~t~13+ ~w~t~15+ ~t~w~9+ ~t~w~7+ ~t~w~7+~n",
           ['#', 'Name', 'Area', 'Cuisine', 'Cost/2', 'Rating', 'Score']),
    format("~`-t~86|~n"),
    print_rows(Ids, 1, Prefs),
    format("~`-t~86|~n").

%! print_rows(+Ids, +Rank, +Prefs) is det.
print_rows([], _, _).
print_rows([Id|T], Rank, Prefs) :-
    restaurant(Id, Name, Area, Cuisine, Cost, _, Rating),
    score(Id, Prefs, Score),
    short_name(Name, Short),
    format("~t~d~4+ ~w~t~37+ ~w~t~13+ ~w~t~15+ ~t~d~9+ ~t~2f~7+ ~t~1f~7+~n",
           [Rank, Short, Area, Cuisine, Cost, Rating, Score]),
    Rank1 is Rank + 1,
    print_rows(T, Rank1, Prefs).

%! short_name(+Name, -Short) is det.
%  Cut very long names so the table stays aligned.
short_name(Name, Short) :-
    atom_length(Name, L),
    (   L > 35
    ->  sub_atom(Name, 0, 33, _, P), atom_concat(P, '..', Short)
    ;   Short = Name
    ).

%! show_ranked(+Prefs, +Limit) is det.
%  Run the search with relaxation, rank, print at most Limit rows (or 'all').
show_ranked(Prefs, Limit) :-
    recommend(Prefs, Ids, Relaxed),
    (   Ids == []
    ->  format("~nNo restaurant found, even after relaxing all constraints.~n")
    ;   (   Relaxed == []
        ->  true
        ;   atomic_list_concat(Relaxed, ', ', Text),
            format("~nNo exact match. Relaxed constraint(s): ~w~n", [Text])
        ),
        rank_by_score(Prefs, Ids, Sorted),
        length(Sorted, Total),
        (   Limit == all -> Shown = Sorted ; take(Limit, Sorted, Shown) ),
        length(Shown, ShownN),
        format("~nShowing ~d of ~d match(es):~n", [ShownN, Total]),
        print_table(Shown, Prefs)
    ).


% ============================================================
% SECTION 5: INPUT HANDLING (robust, never crashes on bad input)
% ============================================================

%! read_answer(+Prompt, -Atom) is det.
%  Read a line, trim it, lower-case it, spaces/hyphens become '_'.
%  Throws eof at end of input (handled in start/0).
read_answer(Prompt, Atom) :-
    atom_string(PromptAtom, Prompt),
    prompt(Old, PromptAtom),          % let the line editor own the prompt so backspace stops at it
    read_line_to_string(user_input, Line),
    prompt(_, Old),
    (   Line == end_of_file
    ->  throw(eof)
    ;   normalize_input(Line, Atom)
    ).

%! normalize_input(+String, -Atom) is det.
normalize_input(String, Atom) :-
    split_string(String, "", " \t\r\n.", [Trimmed]),
    string_lower(Trimmed, Lower),
    split_string(Lower, " -", "", Parts),
    atomic_list_concat(Parts, '_', Atom).

%! to_number(+Atom, -Number) is semidet.
%  Atom is a number (no exceptions on garbage).
to_number(Atom, Number) :-
    catch(atom_number(Atom, Number), _, fail),
    number(Number).

%! ask_choice(+Prompt, -Choice) is det.
%  Menu number 0..7, asks again on bad input.
ask_choice(Prompt, Choice) :-
    read_answer(Prompt, A),
    (   to_number(A, N), integer(N), between(0, 7, N)
    ->  Choice = N
    ;   format("Please type a number from 0 to 7.~n"),
        ask_choice(Prompt, Choice)
    ).

%! ask_cuisine(-Cuisine) is det.
ask_cuisine(Cuisine) :-
    read_answer("Cuisine (or 'any'): ", A),
    (   A == back -> Cuisine = back
    ;   ( A == '' ; A == any ) -> Cuisine = any
    ;   valid_cuisine(A) -> Cuisine = A
    ;   format("Unknown cuisine '~w'. Valid options:~n", [A]),
        all_cuisines(L), print_options(L),
        ask_cuisine(Cuisine)
    ).

%! ask_area(-Area) is det.
ask_area(Area) :-
    read_answer("Area (or 'any'): ", A),
    (   A == back -> Area = back
    ;   ( A == '' ; A == any ) -> Area = any
    ;   all_areas(L), memberchk(A, L) -> Area = A
    ;   format("Unknown area '~w'. Valid options:~n", [A]),
        all_areas(L2), print_options(L2),
        ask_area(Area)
    ).

%! ask_budget(+Prompt, -Budget) is det.
%  A positive number or 'any'.
ask_budget(Prompt, Budget) :-
    read_answer(Prompt, A),
    (   A == back -> Budget = back
    ;   ( A == '' ; A == any ) -> Budget = any
    ;   to_number(A, N), N > 0 -> Budget = N
    ;   format("Please type a positive number (e.g. 1000) or 'any'.~n"),
        ask_budget(Prompt, Budget)
    ).

%! ask_veg(-Veg) is det.
ask_veg(Veg) :-
    read_answer("Veg preference (veg / nonveg / any): ", A),
    (   A == back -> Veg = back
    ;   ( A == '' ; A == any ) -> Veg = any
    ;   A == veg -> Veg = veg
    ;   memberchk(A, [nonveg, non_veg]) -> Veg = nonveg
    ;   format("Please type veg, nonveg or any.~n"),
        ask_veg(Veg)
    ).

%! ask_rating(-Min) is det.
ask_rating(Min) :-
    read_answer("Minimum rating 1-5 (or 'any'): ", A),
    (   A == back -> Min = back
    ;   ( A == '' ; A == any ) -> Min = any
    ;   to_number(A, N), N >= 1, N =< 5 -> Min = N
    ;   format("Please type a number from 1 to 5, or 'any'.~n"),
        ask_rating(Min)
    ).

%! ask_prefs(-Prefs) is det.
ask_prefs(prefs(C, A, B, V, R)) :-
    format("(Type 'back' to return to the previous question.)~n"),
    ask_from(1, [any, any, any, any, any], Vals),
    review(Vals, [C, A, B, V, R]).

%! ask_step(+N, -Answer) is det.
%  Ask preference question number N (1 cuisine .. 5 rating); Answer may be 'back'.
ask_step(1, A) :- ask_cuisine(A).
ask_step(2, A) :- ask_area(A).
ask_step(3, A) :- ask_budget("Max budget for two in INR (or 'any'): ", A).
ask_step(4, A) :- ask_veg(A).
ask_step(5, A) :- ask_rating(A).

%! ask_from(+N, +Vals0, -Vals) is det.
%  Ask questions N..5 in order; 'back' returns to the previous question.
ask_from(N, Vals, Vals) :-
    N > 5, !.
ask_from(N, Vals0, Vals) :-
    ask_step(N, Ans),
    (   Ans == back
    ->  (   N =:= 1
        ->  format("Already at the first question.~n"), N1 = 1
        ;   N1 is N - 1
        ),
        ask_from(N1, Vals0, Vals)
    ;   nth1(N, Vals0, _, Rest),
        nth1(N, Vals1, Ans, Rest),
        N1 is N + 1,
        ask_from(N1, Vals1, Vals)
    ).

%! review(+Vals0, -Vals) is det.
%  Show the answers; the user may re-answer any one (1-5) or press Enter to continue.
review(Vals0, Vals) :-
    Vals0 = [C, A, B, V, R],
    format("~nYour choices:~n  1. Cuisine        : ~w~n  2. Area           : ~w~n  3. Max budget      : ~w~n  4. Veg preference  : ~w~n  5. Minimum rating  : ~w~n",
           [C, A, B, V, R]),
    read_answer("Change which one (1-5), or press Enter to search: ", In),
    (   In == ''
    ->  Vals = Vals0
    ;   to_number(In, N), integer(N), between(1, 5, N)
    ->  ask_step(N, Ans),
        (   Ans == back
        ->  Vals1 = Vals0
        ;   nth1(N, Vals0, _, Rest),
            nth1(N, Vals1, Ans, Rest)
        ),
        review(Vals1, Vals)
    ;   format("Please type a number from 1 to 5, or just press Enter.~n"),
        review(Vals0, Vals)
    ).

%! all_areas(-Areas) is det.
all_areas(Areas) :-
    setof(A, I^in_area(I, A), Areas).

%! all_cuisines(-Cuisines) is det.
%  Every primary cuisine and every tag, sorted, no duplicates.
all_cuisines(Cuisines) :-
    setof(C, I^matches_cuisine(I, C), Cuisines).

%! valid_cuisine(+C) is semidet.
valid_cuisine(C) :-
    all_cuisines(L),
    memberchk(C, L).

%! print_options(+List) is det.
print_options(List) :-
    atomic_list_concat(List, ', ', Text),
    format("  ~w~n", [Text]).


% ============================================================
% SECTION 6: MENU
% ============================================================

%! start is det.
%  Main entry point: menu loop.
start :-
    format("~n=== Surat Restaurant Recommendation System ===~n"),
    catch(menu_loop, eof, format("~nInput ended. Goodbye!~n")).

%! menu_loop is det.
menu_loop :-
    print_menu,
    ask_choice("Your choice: ", Choice),
    (   Choice =:= 0
    ->  format("Goodbye!~n")
    ;   catch(action(Choice), E, handle_error(E)),
        menu_loop
    ).

%! handle_error(+E) is det.
%  Re-throw eof, report anything else without crashing.
handle_error(eof) :- !, throw(eof).
handle_error(E) :-
    format("Something went wrong (~w). Back to the menu.~n", [E]).

%! print_menu is det.
print_menu :-
    format("~n 1. Get recommendations~n"),
    format(" 2. Show all restaurants~n"),
    format(" 3. Search by cuisine only~n"),
    format(" 4. Search by area only~n"),
    format(" 5. Top rated restaurants~n"),
    format(" 6. Budget restaurants (under X)~n"),
    format(" 7. Run built-in sample queries~n"),
    format(" 0. Exit~n").

%! any_prefs(-Prefs) is det.
any_prefs(prefs(any, any, any, any, any)).

%! action(+Choice) is det.
%  Run one menu item.
action(1) :-
    ask_prefs(P),
    top_n(N),
    show_ranked(P, N).
action(2) :-
    findall(Id, restaurant(Id, _, _, _, _, _, _), Ids),
    any_prefs(P),
    format("~nAll restaurants:~n"),
    print_table(Ids, P).
action(3) :-
    ask_cuisine(C),
    (   C == back
    ->  format("Back to the menu.~n")
    ;   show_ranked(prefs(C, any, any, any, any), all)
    ).
action(4) :-
    ask_area(A),
    (   A == back
    ->  format("Back to the menu.~n")
    ;   show_ranked(prefs(any, A, any, any, any), all)
    ).
action(5) :-
    findall(Id, restaurant(Id, _, _, _, _, _, _), Ids),
    rank_by_rating(Ids, Sorted),
    take(10, Sorted, Top),
    any_prefs(P),
    format("~nTop 10 by average rating:~n"),
    print_table(Top, P).
action(6) :-
    ask_budget("Show restaurants with cost for two up to (INR): ", X),
    (   X == back
    ->  format("Back to the menu.~n")
    ;   X == any
    ->  format("Please give a number.~n")
    ;   findall(Id, within_budget(Id, X), Ids),
        (   Ids == []
        ->  format("No restaurant at or below ~w.~n", [X])
        ;   rank_by_rating(Ids, Sorted),
            any_prefs(P),
            format("~nRestaurants up to ~w for two (best rated first):~n", [X]),
            print_table(Sorted, P)
        )
    ).
action(7) :-
    run_samples.


% ============================================================
% SECTION 7: DEMO (built-in sample queries)
% ============================================================

%! sample(+N, +Description, -Prefs) is det.
sample(1, "Italian food in Vesu, up to Rs 1200 for two, any diet, rating 4.0 or more.",
       prefs(italian, vesu, 1200, any, 4.0)).
sample(2, "Pure veg Gujarati food, any area, up to Rs 800, rating 4.0 or more.",
       prefs(gujarati, any, 800, veg, 4.0)).
sample(3, "Cheap eats: any cuisine in Varachha, up to Rs 500, rating 3.5 or more.",
       prefs(any, varachha, 500, any, 3.5)).
sample(4, "Italian in Vesu, up to Rs 1200, rating 4.8 or more (too strict: rating gets relaxed).",
       prefs(italian, vesu, 1200, any, 4.8)).
sample(5, "BBQ in Pal, up to Rs 700, non-veg, rating 4.0 or more (all four relaxation steps needed).",
       prefs(bbq, pal, 700, nonveg, 4.0)).
sample(6, "Sushi, veg only, in Varachha, up to Rs 300, rating 5 (impossible).",
       prefs(sushi, varachha, 300, veg, 5)).

%! run_samples is det.
%  Print six sample queries in English, then their results.
run_samples :-
    forall(sample(N, Text, Prefs),
           (   format("~n~`=t~100|~nSample ~d: ~s~n", [N, Text]),
               Prefs = prefs(C, A, B, V, R),
               format("Query: cuisine=~w, area=~w, budget=~w, veg=~w, min rating=~w~n",
                      [C, A, B, V, R]),
               top_n(Top),
               show_ranked(Prefs, Top)
           )).


% ============================================================
% SECTION 8: TESTS  (run with  ?- run_tests.)
% ============================================================

:- begin_tests(restaurant).

test(data_loaded_100) :-
    aggregate_all(count, restaurant(_, _, _, _, _, _, _), 100).

test(ranking_sorted) :-
    Prefs = prefs(any, any, 2000, any, 3.5),
    find_matches(Prefs, Ids),
    rank_by_score(Prefs, Ids, Sorted),
    findall(S, ( member(I, Sorted), score(I, Prefs, S) ), Scores),
    msort(Scores, Asc),
    reverse(Asc, Desc),
    assertion(Scores == Desc),
    assertion(Sorted \== []).

test(budget_never_exceeded) :-
    forall(member(Max, [300, 500, 800, 1200, 2000]),
           ( find_matches(prefs(any, any, Max, any, any), Ids),
             forall(member(I, Ids),
                    ( restaurant(I, _, _, _, Cost, _, _), Cost =< Max )) )).

test(veg_never_nonveg) :-
    find_matches(prefs(any, any, any, veg, any), Ids),
    assertion(Ids \== []),
    forall(member(I, Ids),
           ( restaurant(I, _, _, _, _, Type, _), Type \== nonveg )).

test(every_restaurant_has_confidence) :-
    forall(restaurant(I, _, _, _, _, _, _), confidence(I, _)).

test(relaxation_reports_constraint) :-
    recommend(prefs(italian, vesu, 1200, any, 5), Ids, Relaxed),
    assertion(Ids \== []),
    assertion(Relaxed \== []).

test(scores_within_100) :-
    forall(restaurant(I, _, _, _, _, _, _),
           ( score(I, prefs(any, any, any, any, any), S), S =< 100, S >= 0 )).

:- end_tests(restaurant).
