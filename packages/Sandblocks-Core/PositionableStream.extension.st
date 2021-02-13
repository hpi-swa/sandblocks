Extension { #name : #PositionableStream }

{ #category : #'*Sandblocks-Core-converting' }
PositionableStream >> asInspector: converter [
	<convert>
	
	converter do: [SBPositionableStreamView new stream: self]
]
