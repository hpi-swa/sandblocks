Class {
	#name : #SBJsClosure,
	#superclass : #SBJsBlockScope,
	#category : #'Sandblocks-CustomJavascript'
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
SBJsClosure >> canDeleteChild: aBlock [

	^ aBlock ~= self arguments
]

{ #category : #'as yet unclassified' }
SBJsClosure >> deleteCommandFor: aBlock [

	^ aBlock = self arguments
		ifTrue: [nil] ifFalse: [super deleteCommandFor: aBlock]
]

{ #category : #'as yet unclassified' }
SBJsClosure >> header [

	^ #()
]

{ #category : #'as yet unclassified' }
SBJsClosure >> initialize [

	super initialize.
	
	self addMorphBack: (SBJsArgumentList new symbols: #('(' ') => '))
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
SBJsClosure >> objectInterfaceNear: aBlock at: aSymbol [

	((#(#replace #before) includes: aSymbol) and: [aBlock ifNotNil: #isFirstChild]) ifTrue: [^ SBInterfaces never].
	^ SBInterfaces jsStatement
]

{ #category : #'as yet unclassified' }
SBJsClosure >> statements [

	^ self submorphs viewAllButFirst
]

{ #category : #'as yet unclassified' }
SBJsClosure >> statementsIndex [

	^ 2
]

{ #category : #'as yet unclassified' }
SBJsClosure >> symbols [

	^ #(nil nil)
]

{ #category : #'as yet unclassified' }
SBJsClosure >> writeSourceOn: aStream [

	aStream nextPutAll: '('.
	self arguments submorphs do: [:a | a writeSourceOn: aStream] separatedBy: [aStream nextPutAll: ', '].
	aStream nextPutAll: ') => {'.
	self statements do: [:s | s writeSourceOn: aStream. aStream nextPut: $;; cr].
	aStream nextPut: $}
]
