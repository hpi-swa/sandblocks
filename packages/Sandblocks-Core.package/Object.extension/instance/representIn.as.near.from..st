*Sandblocks-Core
representIn: aSBEditor as: aSymbol near: aPointOrMorph from: aSourceMorph

	| options position |
	options := self representationsThat: aSymbol.
	options ifEmpty: [^ self].
	position := aPointOrMorph isPoint ifTrue: [aPointOrMorph] ifFalse: [aPointOrMorph position].
	options size > 1
		ifTrue: [ | prompt |
			prompt := SBRepresentationPrompt new.
			aSBEditor openMorphInView: prompt.
			prompt options: options target: self at: position from: aSourceMorph]
		ifFalse: [
			aSBEditor openMorphInView: ((self newFirstSafeOptionFrom: options)
				position: position;
				yourself)]