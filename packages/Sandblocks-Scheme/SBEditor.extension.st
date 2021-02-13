Extension { #name : #SBEditor }

{ #category : #'*Sandblocks-Scheme' }
SBEditor >> createEmptySchemeModule [
	<addAction>

	| module |
	self openMorphInView: (module := SBScmModule new).
	self startInput: module at: 1 replacingContents: true
]