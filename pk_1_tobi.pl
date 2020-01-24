male(george).
male(philip).
male(edward).
male(andrew).
male(mark).
male(charles).
male(kydd).
male(james).
male(mike).
male(peter).
male(harry).
male(william).
male(george).
male(louis).
male(archie).
female(mum).
female(margaret).
female(elizabeth).
female(sophie).
female(sarah).
female(anne).
female(diana).
female(spence).
female(louise).
female(eugenie).
female(beatrice).
female(zara).
female(automn).
female(meghan).
female(kate).
female(grace).
female(mia).
female(isla).
female(savannah).
female(charlotte).
parent_of(george,elizabeth).
parent_of(george,margaret).
parent_of(mum,elizabeth).
parent_of(mum,margaret).
parent_of(elizabeth,charles).
parent_of(elizabeth,anne).
parent_of(elizabeth,andrew).
parent_of(elizabeth,edward).
parent_of(philip,charles).
parent_of(philip,anne).
parent_of(philip,andrew).
parent_of(philip,edward).
parent_of(edward, james).
parent_of(edward, louise).
parent_of(sophie, james).
parent_of(sophie, louise).
parent_of(sarah,eugenie).
parent_of(sarah,beatrice).
parent_of(andrew,beatrice).
parent_of(andrew,eugenie).
parent_of(mark,zara).
parent_of(mark,peter).
parent_of(anne,zara).
parent_of(anne,peter).
parent_of(charles,harry).
parent_of(charles,william).
parent_of(diana,harry).
parent_of(diana,william).
parent_of(zara,miaGrace).
parent_of(mike,miaGrace).
parent_of(peter,isla).
parent_of(peter,savannah).
parent_of(automn,isla).
parent_of(automn,savannah).
parent_of(meghan,archie).
parent_of(harry,archie).
parent_of(kate,louis).
parent_of(kate,charlotte).
parent_of(kate,george1).
parent_of(william,louis).
parent_of(william,charlotte).
parent_of(william,george1).
parent_of(spence,diana).
parent_of(kydd,diana).

married_to(george,mum).
married_to(mum,george).
married_to(elizabeth,philip).
married_to(philip,elizabeth).
married_to(spence,kydd).
married_to(kydd,spence).
married_to(diana,charles).
married_to(charles,diana).
married_to(anne,mark).
married_to(mark,anne).
married_to(sarah,andrew).
married_to(andrew,sarah).
married_to(edward,sophie).
married_to(sophie,edward).
married_to(william,kate).
married_to(kate,william).
married_to(harry,meghan).
married_to(meghan,harry).
married_to(automn,peter).
married_to(peter,automn).
married_to(zara,mike).
married_to(mike,zara).

%rules
father_of(X,Y):- male(X),parent_of(X,Y).
mother_of(X,Y):- female(X), parent_of(X,Y).
son_of(X,Y):- male(X),parent_of(Y,X).
daughter_of(X,Y):- female(X),parent_of(Y,X).

cousin_of(X,Y):- uncle_of(Z,X), parent_of(Z,Y).
cousin_of(X,Y):- aunt_of(Z,X), parent_of(Z,Y).
uncle_of(X,Y):- brother_of(X,Z),parent_of(Z,Y).

aunt_of(X,Y):- sister_of(X,Z),parent_of(Z,Y).

brother_of(X,Y):- male(X),parent_of(Z,X),parent_of(Z,Y),X \= Y.
sister_of(X,Y):- parent_of(Z,X),parent_of(Z,Y),female(X),X \= Y.
grandchild_of(X,Y):- son_of(X,Z),parent_of(Y,Z).
grandchild_of(X,Y):- daughter_of(X,Z),parent_of(Y,Z).

ancestor_of(X,Y):- parent_of(X,Y).
ancestor_of(X,Y):- parent_of(X,Z),ancestor_of(Z,Y).

nephew_of(X,Y):- son_of(X,Z),brother_of(Z,Y).
nephew_of(X,Y):- son_of(X,Z),sister_of(Z,Y).
niece_of(X,Y):- daughter_of(X,Z),sister_of(Z,Y).
niece_of(X,Y):- daughter_of(X,Z),brother_of(Z,Y).

firstcousin_of(X,Y):- cousin_of(Z,X),parent_of(Z,Y).

brotherInLow_of(X,Y):- brother_of(X,Z),married_to(Z,Y).
sisterInLow_of(X,Y):- sister_of(X,Z),married_to(Z,Y).
daughterInLow_of(X,Y):- female(X),married_to(X,Z),parent_of(Y,Z).
sonInLow_of(X,Y):- male(X),married_to(X,Z),parent_of(Y,Z).
fatherInLow_of(X,Y):- male(X),parent_of(X,Z),married_to(Z,Y).
motherInLow_of(X,Y):- female(X),parent_of(X,Z),married_to(Z,Y).
grantparent_of(X,Y):-parent_of(X,Z), parent_of(Z,Y).

greatGrantprent(X,Y):-grantparent_of(X,Z), parent_of(Z,Y).

% Define the relationship between the member family:


relationship(mother,X,Y):-mother_of(X,Y).
relationship(father,X,Y):-father_of(X,Y).
relationship(son,X,Y):-son_of(X,Y).
relationship(daughter,X,Y):-daughter_of(X,Y).
relationship(cousin,X,Y):-cousin_of(X,Y).
relationship(uncle,X,Y):-uncle_of(X,Y).
relationship(aunt,X,Y):-aunt_of(X,Y).
relationship(brother,X,Y):-brother_of(X,Y).
relationship(sister,X,Y):-sister_of(X,Y).
relationship(grandchild,X,Y) :-grandchild_of(X,Y).
relationship(nephew,X,Y):-nephew_of(X,Y).
relationship(niece,X,Y):-niece_of(X,Y).
relationship(brotherInLow,X,Y):-brotherInLow_of(X,Y).
relationship(sisterInLow,X,Y):-sisterInLow_of(X,Y).
relationship(daughterInLow,X,Y):-daughterInLow_of(X,Y).
relationship(sonInLow,X,Y):-sonInLow_of(X,Y).
relationship(fatherInLow,X,Y):-fatherInLow_of(X,Y).
relationship(motherInLow,X,Y):-motherInLow_of(X,Y).
relationship(grantparent,X,Y):-grantparent_of(X,Y).
relationship(greatGrantprent,X,Y):-greatGrantprent(X,Y).
relationship(husbend,X,Y):-male(X),married_to(X,Y).
relationship(wife,X,Y):-female(X),married_to(X,Y).


allMember(X,Y):-relationship(W,X,Y).