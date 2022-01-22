Class {
	#name : #SBMemoize,
	#superclass : #SBStSubstitution,
	#instVars : [
		'identifier'
	],
	#classVars : [
		'Cache'
	],
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #private }
SBMemoize class >> cache [

	^ Cache ifNil: [Cache := Dictionary new]
]

{ #category : #'instance creation' }
SBMemoize class >> do: aBlock identifier: aNumber [

	^ self cache
		at: aNumber
		ifAbsent: [ | value |
			value := aBlock value.
			self cache at: aNumber put: value.
			self triggerEvent: #cacheChanged with: aNumber.
			value]
]

{ #category : #examples }
SBMemoize class >> example [

	SBMemoize do: [WebClient httpGet: 'https://google.com'] identifier: 123123
]

{ #category : #suggestions }
SBMemoize class >> instanceSuggestion [

	^ [
		self new
			expression: SBStGrammarHandler new newNullBlock;
			identifier: self newIdentifier]
]

{ #category : #testing }
SBMemoize class >> matches: aMessageSend [

	(super matches: aMessageSend) ifFalse: [^ false].
	^ self selector: 'do:identifier:' receiverMatches: aMessageSend
]

{ #category : #'instance creation' }
SBMemoize class >> newFor: aMessageSend [

	| args |
	args := aMessageSend arguments.
	^ self new
		expression: args first;
		identifier: args second parsedContents;
		yourself
]

{ #category : #private }
SBMemoize class >> newIdentifier [

	| i |
	i := self cache size.
	[self cache includesKey: i] whileTrue: [i := i + 1].
	^ i
]

{ #category : #'as yet unclassified' }
SBMemoize >> cacheChanged: aNumber [

	aNumber = self identifier ifTrue: [
		self class cache
			at: self identifier
			ifPresent: [:object |
				self lastSubmorph lastSubmorph
					addMorphBack: (SBIcon iconSearch
						on: #click send: #exploreCached to: self;
						balloonText: 'Explore cached value';
						yourself);
					addMorphBack: (SBStringMorph new
						contents: (object printStringLimitedTo: 20);
						yourself)]]
]

{ #category : #'as yet unclassified' }
SBMemoize >> drawnColor [

	^ self colorPolicy toolColorFor: self
]

{ #category : #'as yet unclassified' }
SBMemoize >> exploreCached [
	<action>

	self sandblockEditor openMorphInView: (SBExplorer on: (self class cache at: self identifier))
]

{ #category : #'as yet unclassified' }
SBMemoize >> expression [

	^ self firstSubmorph firstSubmorph
]

{ #category : #'as yet unclassified' }
SBMemoize >> expression: aBlock [

	self firstSubmorph addMorphFront: aBlock
]

{ #category : #'as yet unclassified' }
SBMemoize >> identifier [

	^ identifier
]

{ #category : #'as yet unclassified' }
SBMemoize >> identifier: aNumber [

	identifier := aNumber.
	self cacheChanged: aNumber
]

{ #category : #'as yet unclassified' }
SBMemoize >> initialize [

	super initialize.
	self
		changeTableLayout;
		layoutInset: 4;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		addMorphBack: (SBColumn new
			cellGap: 12;
			addMorphBack: (SBRow new
				addMorphBack: SBIcon iconSave;
				cellGap: 12)).
	self class when: #cacheChanged send: #cacheChanged: to: self
]

{ #category : #'as yet unclassified' }
SBMemoize >> newIdentifier [

	self identifier: Random new nextValue
]

{ #category : #'as yet unclassified' }
SBMemoize >> removeCached [
	<action>

	self class cache removeKey: self identifier
]

{ #category : #'as yet unclassified' }
SBMemoize >> writeSourceOn: aStream [

	aStream
		nextPut: $(;
		nextPutAll: self className;
		nextPutAll: ' do: '.
	self expression writeSourceOn: aStream.
	aStream
		nextPutAll: ' identifier: ';
		nextPutAll: self identifier storeString;
		nextPut: $)
]
