Extension { #name : #FileStream }

{ #category : #'*Sandblocks-Scheme-converting' }
FileStream >> parseAsScheme: converter [
	<convert>
	
	converter
		if: [self name endsWith: '.scm']
		do: [SBScmModule fromFilestream: self]
]
