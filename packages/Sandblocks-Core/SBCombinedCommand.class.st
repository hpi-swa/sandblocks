Class {
	#name : #SBCombinedCommand,
	#superclass : #SBCommand,
	#instVars : [
		'commands'
	],
	#category : 'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBCombinedCommand class >> newWith: aCollection [

	^ self basicNew
		initialize;
		commands: aCollection;
		yourself
]

{ #category : #'as yet unclassified' }
SBCombinedCommand >> affectedArtefacts [
	" if we non-edit commands within our list we also may get nil artifacts "

	^ ((self commands gather: #affectedArtefacts) select: #notNil) asSet
]

{ #category : #'as yet unclassified' }
SBCombinedCommand >> commands [

	^ commands
]

{ #category : #'as yet unclassified' }
SBCombinedCommand >> commands: aCollection [

	commands := aCollection
]

{ #category : #'as yet unclassified' }
SBCombinedCommand >> do [

	self commands allButLastDo: #do.
	^ self commands last do
]

{ #category : #'as yet unclassified' }
SBCombinedCommand >> hasHorizontalLayout [

	^ self commands
		detect: [:c | c respondsTo: #container]
		ifFound: [:c | c container hasHorizontalLayout]
		ifNone: [false]
]

{ #category : #'as yet unclassified' }
SBCombinedCommand >> hasSamePositionAs: aCommand [

	aCommand class = self class ifFalse: [^ false].
	
	self commands
		with: aCommand commands
		do: [:a :b | (a hasSamePositionAs: b) ifFalse: [^ false]].
	^ true
]

{ #category : #'as yet unclassified' }
SBCombinedCommand >> postDo [

	commands do: #postDo
]

{ #category : #'as yet unclassified' }
SBCombinedCommand >> preDo [

	^ commands do: #preDo
]

{ #category : #'as yet unclassified' }
SBCombinedCommand >> previousSelection [

	^ previousSelection ifNil: [self commands first previousSelection]
]

{ #category : #'as yet unclassified' }
SBCombinedCommand >> secondaryInsertPosition [

	^ self commands anySatisfy: [:command | command secondaryInsertPosition]
]

{ #category : #'as yet unclassified' }
SBCombinedCommand >> selectAfter [

	^ selectAfter ifNil: [self commands last selectAfter]
]

{ #category : #'as yet unclassified' }
SBCombinedCommand >> setArtefactFrom [

	^ nil
]

{ #category : #'as yet unclassified' }
SBCombinedCommand >> shouldMergeWithNext [

	^ self commands last shouldMergeWithNext
]

{ #category : #'as yet unclassified' }
SBCombinedCommand >> shouldMergeWithNext: aBoolean [

	self commands last shouldMergeWithNext: aBoolean
]

{ #category : #'as yet unclassified' }
SBCombinedCommand >> title [

	^ self commands first title
]

{ #category : #'as yet unclassified' }
SBCombinedCommand >> undo [

	self commands allButFirst reverseDo: #undo.
	^ self commands first undo
]

{ #category : #'as yet unclassified' }
SBCombinedCommand >> valid [

	^ commands notEmpty
]
