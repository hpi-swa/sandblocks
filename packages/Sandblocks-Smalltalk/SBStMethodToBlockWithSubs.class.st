Class {
	#name : #SBStMethodToBlockWithSubs,
	#superclass : #SBStMethodToBlocks,
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #'as yet unclassified' }
SBStMethodToBlockWithSubs >> visitCascadeNode: aNode [

	| cascade |
	cascade := super visitCascadeNode: aNode.
	
	SBStSubstitution allSubclassesDo: [:substitution | (substitution matchesCascades and: [substitution matches: cascade]) ifTrue: [^ (substitution newFor: cascade) pc: cascade pc]].
	
	cascade converterOptionsDo: [:option | | c |
		c := SBConvert new success: [:obj | ^ obj].
		option automatic ifTrue: [option apply: c]].
	
	^ cascade
]

{ #category : #'as yet unclassified' }
SBStMethodToBlockWithSubs >> visitMessageNode: aNode [

	| block |
	block := super visitMessageNode: aNode.
	block receiver ifNotNil: [
		SBStSubstitution allSubclassesDo: [:substition | ((substition matches: block) and: [substition applyAutomatically]) ifTrue: [^ (substition newFor: block) pc: block pc]].
		block converterOptionsDo: [:option | | c |
			c := SBConvert new success: [:obj | ^ obj].
			option automatic ifTrue: [option apply: c]]].
	
	^ block
]

{ #category : #'as yet unclassified' }
SBStMethodToBlockWithSubs >> visitMessageNodeInCascade: aMessageNode [

	^ super visitMessageNode: aMessageNode
]

{ #category : #'as yet unclassified' }
SBStMethodToBlockWithSubs >> visitMethodNode: aNode [

	| method |
	method := super visitMethodNode: aNode.
	
	SBStMethodSubstitution allSubclassesDo: [:substitution | (substitution matches: method) ifTrue: [^ substitution newFrom: method]].
	
	^ method
]

{ #category : #'as yet unclassified' }
SBStMethodToBlockWithSubs >> visitPragma: aPragma [

	| block |
	block := super visitPragma: aPragma.
	block converterOptionsDo: [:option | | c |
		c := SBConvert new success: [:obj | ^ obj].
		option automatic ifTrue: [option apply: c]].
	^ block
]
