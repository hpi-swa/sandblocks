Class {
	#name : #SBScmLanguageBox,
	#superclass : #SBScmASTNode,
	#category : #'Sandblocks-Scheme'
}

{ #category : #'as yet unclassified' }
SBScmLanguageBox class >> lang: aString source: anotherString [

	^ self new lang: aString source: anotherString
]

{ #category : #'as yet unclassified' }
SBScmLanguageBox >> asSExpression: convert [
	<convert>

	convert do: [
		SBScmExpression new addAllMorphs: {
			SBScmSymbol new contents: 'eval-lang'.
			SBScmString new contents: self language contents.
			SBScmString new contents: self root prettySourceString
		}]
]

{ #category : #'as yet unclassified' }
SBScmLanguageBox >> childSandblocksDo: aBlock [

	aBlock value: self root
]

{ #category : #'as yet unclassified' }
SBScmLanguageBox >> drawnColor [

	^ self root drawnColor
]

{ #category : #'as yet unclassified' }
SBScmLanguageBox >> ifDefinition: aBlock otherwise: anotherBlock [

	^ anotherBlock value
]

{ #category : #'as yet unclassified' }
SBScmLanguageBox >> initialize [

	super initialize.
	
	self
		layoutInset: 2
]

{ #category : #'as yet unclassified' }
SBScmLanguageBox >> isExpression [

	^ true
]

{ #category : #'as yet unclassified' }
SBScmLanguageBox >> isSExpr [

	^ true
]

{ #category : #'as yet unclassified' }
SBScmLanguageBox >> lang: aString source: anotherString [

	self
		removeAllMorphs;
		addMorphBack: (SBStringMorph new contents: aString);
		addMorphBack: (SBStContainer new setFromSource: anotherString)
]

{ #category : #'as yet unclassified' }
SBScmLanguageBox >> language [

	^ self firstSubmorph
]

{ #category : #'as yet unclassified' }
SBScmLanguageBox >> layoutCommands [

	^ SBAlgebraCommand container
		morph: self;
		data: {self language layoutCommands. SBAlgebraCommand hardLine. self root layoutCommands}
]

{ #category : #'as yet unclassified' }
SBScmLanguageBox >> root [

	^ self submorphs second
]

{ #category : #'as yet unclassified' }
SBScmLanguageBox >> writeSourceOn: aStream [

	aStream nextPutAll: '(eval-lang '.
	(SBScmString new contents: self firstSubmorph contents) writeSourceOn: aStream.
	aStream space.
	(SBScmString new contents: self submorphs second prettySourceString) writeSourceOn: aStream.
	aStream nextPutAll: ')'
]

{ #category : #'as yet unclassified' }
SBScmLanguageBox >> writeSourceOn: aStream indent: aNumber [

	self writeSourceOn: aStream
]
