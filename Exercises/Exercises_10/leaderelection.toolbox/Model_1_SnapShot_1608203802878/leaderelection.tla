--------------------------- MODULE leaderelection ---------------------------

EXTENDS Naturals, Sequences, FiniteSets

CONSTANTS N, id

VARIABLES inbox, outbox, elected

Node == 1 .. N

Id == {i \in Nat : \E n \in Node : id[n] = i}

ASSUME
    /\ N \in Nat \ {0}
    /\ id \in Seq(Nat)
    /\ Len(id) = N
    \* # == diferente
    /\ \A m,n \in Node : m # n => id[m] # id[n]

succ(n) == IF n = N THEN 1 ELSE n+1

Init ==
    /\ inbox = [n \in Node |-> {}]
    /\ outbox = [n \in Node |-> {id[n]}]
    /\ elected = {}

send(n) == \E i \in outbox[n] :
    \* @ == atual; x \ y == x - y; x \cup y == x + y
    /\ outbox' = [outbox EXCEPT ![n] = @ \ {i}]
    /\ inbox' = [inbox EXCEPT ![succ(n)] = @ \cup {i}]
    /\ UNCHANGED <<elected>>

compute(n) == \E i \in inbox[n] :
    /\ inbox' = [inbox EXCEPT ![n] = @ \ {i}]
    /\ outbox' = [outbox EXCEPT ![n] = @ \cup IF i > id[n] THEN {i} ELSE {}]
    /\ elected' = elected \cup IF i = id[n] THEN {i} ELSE {}

Next == \E n \in Node : send(n) \/ compute(n)

state == << inbox, outbox, elected >>

Spec == Init /\ [] [Next]_state /\ WF_state(Next)

TypesOk ==
    /\ elected \subseteq Id
    /\ inbox \in [Node -> SUBSET(Id)]
    /\ outbox \in [Node -> SUBSET(Id)]

Safety == [] (Cardinality(elected) <= 1)



=============================================================================
\* Modification History
\* Last modified Thu Dec 17 11:15:58 WET 2020 by goncalo
\* Created Thu Dec 17 10:42:38 WET 2020 by goncalo
