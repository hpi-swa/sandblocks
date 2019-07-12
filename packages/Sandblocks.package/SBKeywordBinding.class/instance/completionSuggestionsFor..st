as yet unclassified
completionSuggestionsFor: aString

	| baseClass |
	baseClass := nil.
	self contents = 'self' ifTrue: [baseClass := self containingMethod methodClass].
	self contents = 'super' ifTrue: [baseClass := self containingMethod methodClass superclass].
	self contents = 'thisContext' ifTrue: [baseClass := Context].
	self contents = 'nil' ifTrue: [baseClass := UndefinedObject].
	self contents  = 'false' ifTrue: [baseClass := False].
	self contents = 'true' ifTrue: [baseClass := True].
	
	baseClass ifNil: [^ super completionSuggestionsFor: aString].
	
	aString size < 2
		ifTrue: [#()]
		ifFalse: [
			^ Array streamContents: [:stream |
				baseClass withAllSuperclassesDo: [:class |
					class methodsDo: [:m | | sel |
						sel := m selector asString.
						(sel sandblockMatch: aString) ifTrue: [stream nextPut: sel]]]]]