CONSTANTS Worker

VARIABLES Prepared, Committed, Aborted
Init == Prepared = {} /\ Committed = {} /\ Aborted = {}

\*Init ==
\*	/\ Prepared = {}
\*	/\ Committed = {}
\*  /\ Aborted = {}

Finish(w) ==
	/\ w \notin Prepared
	/\ w \not in Aborted
	/\ Prepared' = Prepared \cup {w}
	/\ Committed' = Committed
	/\ Aborted' = Aborted
\*	/\ UNNCHANGED << Aborted, Committed >> é igual às 2 linhas de cima

Abort(w) ==
	/\ w \notin Aborted
	/\ w \in Prepared => Aborted # {}
	/\ Prepared' = Prepared \ {w}
	/\ Aborted' = Aborted \cup {w}
	/\ UNCHANGED << Committed >>

Commit(w) == 
	/\ w \in Prepared \ Committed
	/\ Aborted = {}
	/\ Committed' = Committed \cup {w}
	/\ UNCHANGED << Prepared, Aborted >>

\* \E existe um
Next == \E w \in Worker : Finish(w) \/ Abort(w) \/ Comit(w)

vars = << Prepared, Committed, Aborted>>

\* isto é o mesmo que o nop, esses nao vao variar
Spec == Init /\ [] [Next]_vars

\*always  	 []
\*eventually <>

Consistency == [] (Committed = {} \/ Aborted = {})
Stability == \A w \in Worker:
						/\ [] (w \in Committed => (w \in Committed))
						/\ [] (w \in Aborted => (w \in Aborted))
\* [] (a => <> b)
\*  a~>b      são as 2 iguais
