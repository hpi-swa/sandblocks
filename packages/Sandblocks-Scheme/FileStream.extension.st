Extension { #name : #FileStream }

{ #category : #'*Sandblocks-Scheme-converting' }
FileStream >> parseAsScheme: converter [
	<convert>
	
	converter
		do: [SBScmModule fromFilestream: self]
]
