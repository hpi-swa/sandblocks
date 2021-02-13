Extension { #name : #FileStream }

{ #category : #'*Sandblocks-Core-converting' }
FileStream >> asString: converter [
	<convert>

	converter
		if: [self closed not]
		do: [self ascii; contents]
]

{ #category : #'*Sandblocks-Core-converting' }
FileStream >> asStringReopened: converter [
	<convert>

	converter
		if: [self closed]
		do: [self reopen; ascii; contents]
]

{ #category : #'*Sandblocks-Core-converting' }
FileStream >> parseAsScheme: converter [
	<convert>
	
	converter
		do: [SBScmModule fromFilestream: self]
]
