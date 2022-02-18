Extension { #name : #Object }

{ #category : #'*Sandblocks-Representation' }
Object >> openExplorer: convert [
	<convert>
	<convertPriority: -1>

	convert do: [SBExplorer on: self]
]
