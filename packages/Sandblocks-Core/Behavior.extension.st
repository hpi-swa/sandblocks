Extension { #name : #Behavior }

{ #category : #'*Sandblocks-Core-converting' }
Behavior >> open: converter [
	<convert>
	
	converter do: [SBClass newFor: self at: 0 @ 0]
]

{ #category : #'*Sandblocks-Core-converting' }
Behavior >> openFull: converter [
	<convert>
	
	converter do: [SBClassMethodEditor new class: self]
]
