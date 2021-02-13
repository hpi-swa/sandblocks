Extension { #name : #FormCanvas }

{ #category : #'*Sandblocks-Core-converting' }
FormCanvas >> asSnapshot: converter [
	<convert>
	
	converter do: [form]
]
