female(mum).
female(elizabeth).
female(margaret).
female(anne).
female(zara).
female(beatrice).
female(louise).
female(charlotte).
female(savannah).
female(isla).
female(mia_grace).
female(kydd).
female(diana).
female(sarah).
female(sophie).
female(kate).
female(meghan).

male(charles).
male(andrew).
male(edward).
male(william).
male(harry).
male(peter).
male(eugenie).
male(james).
male(george_max).
male(george_mini).
male(philip).
male(mark).
male(autmn).
male(mike).
male(archie).

parent(mum, margaret).
parent(mum, elizabeth).
parent(elizabeth, charles).
parent(elizabeth, anne).
parent(elizabeth, andrew).
parent(elizabeth, edward).
parent(spence, diana).
parent(charles, william).
parent(charles, harry).
parent(anne, peter).
parent(anne, zara).
parent(andrew, beatrice).
parent(andrew, eugenie).
parent(edward, louise).
parent(edward, james).
parent(william, george_mini).
parent(william, charlotte).
parent(william, louis).
parent(harry, archie).
parent(peter, savannah).
parent(peter, isla).
parent(zara, mia_grace).

parent(george_aplha, margaret).
parent(george_aplha, elizabeth).
parent(philip, charles).
parent(philip, anne).
parent(philip, andrew).
parent(philip, edward).
parent(kydd, diana).
parent(diana, william).
parent(diana, harry).
parent(mark, peter).
parent(mark, zara).
parent(sarah, beatrice).
parent(sarah, eugenie).
parent(sophie, louise).
parent(sophie, james).
parent(kate, george_mini).
parent(kate, charlotte).
parent(kate, louis).
parent(meghan, archie).
parent(autmn, savannah).
parent(autmn, isla).
parent(mike, mia_grace).

partner(george_aplha, mum).
partner(elizabeth, philip).
partner(charles, diana).
partner(anne, mark).
partner(andrew, sarah).
partner(edward, sophie).
partner(william, kate).
partner(harry, meghan).
partner(peter, autmn).
partner(zara, mike).
partner(spence, kydd).

partner(mum, george_aplha).
partner(philip, elizabeth).
partner(diana, charles).
partner(mark, anne).
partner(sarah, andrew).
partner(sophie, edward).
partner(kate, william).
partner(meghan, harry).
partner(autmn, peter).
partner(mike, zara).
partner(kydd, spence).

child(X, Y) :- parent(Y, X).

decended(X, Y) :- child(X, Y).
decended(X, Y) :- child(X, Z), decended(Z, Y).

ancestor(X, Y) :- decended(Y, X).

relative(X, X).
relative(X, Y) :- decended(X, Y); decended(Y, X).
relative(X, Y) :- decended(X, Z), decended(Y, Z).

royal(mum).
royal(X) :- child(X, Y), royal(Y).

parallel(X, X).
parallel(W, X) :- parent(Y, W), parent(Z, X), parallel(Y, Z).

directline(X, X, 0).
directline(X, Z, N) :- parent(Y, X), directline(Y, Z, N_), N is N_+1.
direct(X, Y, N) :- directline(X, Y, N); directline(Y, X, N).

vertical(X, X, 0).
vertical(X, Y, N) :-  parallel(Y, Z), direct(X, Z, N).

horizontal_parallel(X, X, 0).
horizontal_parallel(X, Y, N) :- child(X, X_), child(Y, Y_), horizontal_parallel(X_, Y_, N_), not(X = Y), N is N_+1.

horizontal(X, Y, N) :- horizontal_parallel(X, Y, N); horizontal_parallel(X, Z, N), decended(Y, Z); horizontal_parallel(Y, Z, N), decended(X, Z).

daughter(X, Y) :- female(X), child(X, Y).
son(X, Y) :- male(X), child(X, Y).
mother(X, Y) :- female(X), parent(X, Y).
father(X, Y) :- male(X), parent(X, Y).
niece(X, Y) :- female(X), parent(X, Z), siblings(Y, Z).
nephew(X, Y) :- male(X), parent(X, Z), siblings(Y, Z).
daughterinlaw(X, Y) :- female(X), partner(X, Z), child(Z, Y).
soninlaw(X, Y) :- male(X), partner(X, Z), child(Z, Y).
motherinlaw(X, Y) :- partner(Y, Z), mother(X, Z).
fatherinlaw(X, Y) :- partner(Y, Z), father(X, Z).
grandchild(X, Z) :- child(X, Y), child(Y, Z).
grandparent(X, Y) :- grandchild(Y, X).
greatgrandchild(X, Z) :- child(X, Y), grandchild(Y, Z).
greatgrandparent(X, Y) :- greatgrandchild(Y, X).
siblings(X, Y) :- horizontal_parallel(X, Y, 1).
sister(X, Y) :- siblings(X, Y), female(X).
brother(X, Y) :- siblings(X, Y), male(X).
firstcousin(X, Y) :- horizontal_parallel(X, Y, 2).
inlaw_(X, Z) :- siblings(X, Y), partner(Y, Z).
inlaw(X, Y) :- inlaw_(Y, X); inlaw_(X, Y).
brotherinlaw(X, Y) :- male(X), inlaw(X, Y).
sisterinlaw(X, Y) :- female(X), inlaw(X, Y).
uncle(X, Z) :- siblings(X, Y), child(Z, Y), male(X).
aunt(X, Z) :- siblings(X, Y), child(Z, Y), female(X).

relation(X, Y, daughter) :- daughter(X, Y).
relation(X, Y, son) :- son(X, Y).
relation(X, Y, mother) :- mother(X, Y).
relation(X, Y, father) :- father(X, Y).
relation(X, Y, niece) :- niece(X, Y).
relation(X, Y, nephew) :- nephew(X, Y).
relation(X, Y, daughterinlaw) :- daughterinlaw(X, Y).
relation(X, Y, soninlaw) :- soninlaw(X, Y).
relation(X, Y, motherinlaw) :- motherinlaw(X, Y).
relation(X, Y, fatherinlaw) :- fatherinlaw(X, Y).
relation(X, Y, grandchild) :-grandchild(X, Y).
relation(X, Y, grandparent) :- grandparent(X, Y).
relation(X, Y, greatgrandchild) :- greatgrandchild(X, Y).
relation(X, Y, greatgrandparent) :- greatgrandparent(X, Y).
relation(X, Y, siblings) :- (X, Y).
relation(X, Y, sister) :- sister(X, Y).
relation(X, Y, brother) :- brother(X, Y).
relation(X, Y, firstcousin) :- firstcousin(X, Y).
relation(X, Y, inlaw) :- inlaw(X, Y).
relation(X, Y, brotherinlaw) :- brotherinlaw(X, Y).
relation(X, Y, sisterinlaw) :- sisterinlaw(X, Y).
relation(X, Y, uncle) :- uncle(X, Y).
relation(X, Y, aunt) :- aunt(X, Y).

cousin(X, Y, N, M) :- horizontal(X, Y, N_), vertical(X, Y, M), N is N_-1, !     .


% rel(daugher).
% getrel(X,Y,R):- rel(Rel), call(Rel,X,Y).

%-? daughter(X,Y)

a2b([],[]).
a2b([a|TA],[b|TB]) :- a2b(TA, TB).
a2b(TA,[X|TB]) :- a2b(TA, TB), X\=a.
a2b([X|TA], TB) :- a2b(TA, TB), X\=b.
