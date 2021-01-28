Extension { #name : #SBEditor }

{ #category : #'*Sandblocks-Javascript' }
SBEditor >> createEmptyJavascriptMethod [
	<addAction>

	| module |
	self openMorphInView: (module := SBJsMethod new).
	self startInput: module at: 1 replacingContents: true
]
