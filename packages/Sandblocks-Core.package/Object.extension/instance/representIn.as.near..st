*Sandblocks-Core
representIn: aMorph as: aSymbol near: aPointOrMorph

	| options representation |
	options := self representationsThat: aSymbol.
	options ifEmpty: [^ self].
	representation := self newFirstSafeOptionFrom: options.
	options size > 1 ifTrue: [ | prompt |
		prompt := SBRepresentationPrompt new options: options target: self current: representation.
		aMorph openMorphInView: prompt.
		prompt position: (aPointOrMorph isPoint ifTrue: [aPointOrMorph] ifFalse: [aPointOrMorph position]).
		aMorph openMorphInView: representation].
	^ representation