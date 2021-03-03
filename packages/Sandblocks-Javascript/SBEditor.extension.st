Extension { #name : #SBEditor }

{ #category : #'*Sandblocks-Javascript' }
SBEditor >> createEmptyJavascriptModule [
	<addAction>
	<label: 'Javascript Module'>

	| module |
	self openMorphInView: (module := SBJsModule new).
	self startInput: module at: 1 replacingContents: true
]
