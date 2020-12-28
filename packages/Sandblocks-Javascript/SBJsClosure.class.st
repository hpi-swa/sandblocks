Class {
	#name : #SBJsClosure,
	#superclass : #SBJsBlockScope,
	#category : #'Sandblocks-Javascript'
}

{ #category : #'as yet unclassified' }
SBJsClosure >> arguments [

	^ self firstSubmorph
]

{ #category : #'as yet unclassified' }
SBJsClosure >> arguments: aCollection statements: anotherCollection [

	self arguments addAllMorphs: aCollection.
	self addAllMorphs: anotherCollection
]

{ #category : #'as yet unclassified' }
SBJsClosure >> binding: aString for: block class: aClass ifPresent: aBlock [

	self arguments submorphs detect: [:arg | arg contents = aString] ifFound: [:arg | ^ aBlock value: arg] ifNone: [].
	
	^ super binding: aString for: block class: aClass ifPresent: aBlock
]

{ #category : #'as yet unclassified' }
SBJsClosure >> childSandblocksDo: aBlock [

	self arguments childSandblocksDo: aBlock.
	"aBlock value: self arguments."
	super childSandblocksDo: aBlock
]

{ #category : #'as yet unclassified' }
SBJsClosure >> deleteCommandFor: aBlock [

	^ aBlock = self arguments
		ifTrue: [nil] ifFalse: [super deleteCommandFor: aBlock]
]

{ #category : #'as yet unclassified' }
SBJsClosure >> initialize [

	super initialize.
	
	self addMorphBack: (SBValueList new symbols: #('(' ') => '))
]

{ #category : #'as yet unclassified' }
SBJsClosure >> isExpression [

	^ self isMethodBody not
]

{ #category : #'as yet unclassified' }
SBJsClosure >> layoutCommands [

	^ SBAlgebraCommand container
		morph: self;
		data: {
			self arguments layoutCommands.
			SBAlgebraCommand indent data: {
				(self statements size > 1 or: [self isMethodBody])
					ifTrue: [SBAlgebraCommand hardLine withGap: true]
					ifFalse: [SBAlgebraCommand softLineOrGap withGap: true]
			}, self layoutCommandsForStatements
		}
]

{ #category : #'as yet unclassified' }
SBJsClosure >> statements [

	^ self submorphs viewAllButFirst
]

{ #category : #'as yet unclassified' }
SBJsClosure >> symbols [

	^ #(nil nil)
]
