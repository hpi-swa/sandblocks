Class {
	#name : #SBStPlayground,
	#superclass : #SBStContainer,
	#instVars : [
		'bindings'
	],
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #'instance creation' }
SBStPlayground class >> example [

	^ self newFromSource: '{1. 2. 3. 4} collect: [:ea | ea squared]'
]

{ #category : #'instance creation' }
SBStPlayground class >> newFromSource: aString [

	^ (self newFromSource: aString named: 'Workspace')
]

{ #category : #'instance creation' }
SBStPlayground class >> newFromSource: aString at: aPoint [

	^ (self newFromSource: aString)
		position: aPoint;
		yourself
]

{ #category : #'instance creation' }
SBStPlayground class >> newFromSource: aString named: anotherString [

	^ self new
		 setFromSource: aString;
		 name: anotherString;
		 yourself
]

{ #category : #'instance creation' }
SBStPlayground class >> newFromSource: aString named: anotherString at: aPoint [

	^ (self newFromSource: aString named: anotherString)
		position: aPoint;
		yourself
]

{ #category : #'as yet unclassified' }
SBStPlayground >> binding: aString for: block class: aClass ifPresent: aBlock [

	bindings submorphs detect: [:b | b contents = aString] ifFound: [:v | ^ aBlock value: v].
	
	aString = 'sbEditor' ifTrue: [^ aBlock value: ((SBStName poolDeclaration: aString) binding: #sbEditor -> self sandblockEditor)].
	
	^ super binding: aString for: block class: aClass ifPresent: aBlock
]

{ #category : #'as yet unclassified' }
SBStPlayground >> bindingOf: aString [

	aString = 'sbEditor' ifTrue: [^ #sbEditor -> self sandblockEditor].
	
	^ (self getOrCreateLocalBinding: aString) binding
]

{ #category : #'as yet unclassified' }
SBStPlayground >> bindings [

	^ bindings
]

{ #category : #'as yet unclassified' }
SBStPlayground >> bindings: aDictionary [

	bindings := aDictionary
]

{ #category : #'as yet unclassified' }
SBStPlayground >> canDeleteChild: aBlock [

	^ aBlock owner = bindings
]

{ #category : #'as yet unclassified' }
SBStPlayground >> copyString [
	<action>

	self body performAction: #copyString
]

{ #category : #'as yet unclassified' }
SBStPlayground >> createBinding: aString [

	| decl |
	decl := (SBStName contents: aString)
		binding: aString -> nil;
		yourself.
	bindings addMorphBack: decl.
	self changed.
	^ decl
]

{ #category : #'as yet unclassified' }
SBStPlayground >> declarations [

	^ bindings submorphs
]

{ #category : #'as yet unclassified' }
SBStPlayground >> evaluateExpression [
	<action>
	
	| send |
	send := SBStMessageSend new receiver: self body veryDeepCopy selector: #value.
	[self addMorphBack: send.
	send evaluateExpression] ensure: [send delete]
]

{ #category : #'as yet unclassified' }
SBStPlayground >> getOrCreateLocalBinding: aString [

	^ bindings submorphs detect: [:block | block contents = aString] ifNone: [self createBinding: aString]
]

{ #category : #'as yet unclassified' }
SBStPlayground >> handleDroppedBlock: aBlock event: anEvent adding: aBoolean near: aMorph [

	| object |
	object := aBlock unpackSelection object.
	(self createBinding: object name asLegalSelector) binding value: object
]

{ #category : #'as yet unclassified' }
SBStPlayground >> initialize [

	super initialize.
	
	self
		addMorphFront: (SBRow new
			cellGap: 8 withScalingFactor;
			addMorphBack: (SBTextBubble new
				layoutInset: 4 withScalingFactor;
				colored: false;
				color: Color white;
				contents: 'Workspace');
			addMorphBack: (bindings := SBRow new cellGap: 4 withScalingFactor));
		vResizing: #shrinkWrap;
		hResizing: #rigid;
		attachDecorator: SBMoveDecorator new;
		attachDecorator: SBResizableDecorator new
]

{ #category : #'as yet unclassified' }
SBStPlayground >> isEditor [

	^ true
]

{ #category : #'as yet unclassified' }
SBStPlayground >> isRepl [

	^ true
]

{ #category : #'as yet unclassified' }
SBStPlayground >> layoutCommands [

	^ SBAlgebraCommand container
		morph: self;
		data: {
			SBAlgebraCommand morph data: self firstSubmorph.
			SBAlgebraCommand hardLine withGap: true.
			self lastSubmorph layoutCommands
		}
]

{ #category : #'as yet unclassified' }
SBStPlayground >> localVariables [

	^ bindings
]

{ #category : #'as yet unclassified' }
SBStPlayground >> name [

	^ self firstSubmorph firstSubmorph contents
]

{ #category : #'as yet unclassified' }
SBStPlayground >> name: aString [

	self firstSubmorph firstSubmorph contents: aString
]

{ #category : #'as yet unclassified' }
SBStPlayground >> objectInterfaceAt: aNumber adding: aBoolean [

	^ SBInterfaces always
]

{ #category : #'as yet unclassified' }
SBStPlayground >> receiver: anObject [

	anObject ifNotNil: [self name: (anObject asString truncateWithElipsisTo: 20)].
	super receiver: anObject
]

{ #category : #'as yet unclassified' }
SBStPlayground >> storeOn: aStream [

	SBExample
		self: [SBStPlayground newFromSource: '5 + 5 squared' named: 'REPL']
		args: [{'' writeStream}]
		label: 'simple'.
	aStream nextPut: $(.
	aStream nextPutAll: self className.
	aStream nextPutAll: ' newFromSource: '.
	self body prettySourceString storeOn: aStream.
	aStream nextPutAll: ' named: '.
	self name storeOn: aStream.
	aStream nextPutAll: ' at: '.
	self position storeOn: aStream.
	aStream nextPut: $)
]

{ #category : #'as yet unclassified' }
SBStPlayground >> textContents [

	^ self name
]
