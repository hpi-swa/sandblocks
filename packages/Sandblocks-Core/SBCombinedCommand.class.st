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

{ #category : #accessing }
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

{ #category : #'insert commands' }
SBCombinedCommand >> container [

	^ self commands detect: [:c | c isInsert] ifFound: [:c | c container] ifNone: [nil]
]

{ #category : #apply }
SBCombinedCommand >> do [

	self commands allButLastDo: #do.
	^ self commands last do
]

{ #category : #'insert commands' }
SBCombinedCommand >> hasHorizontalLayout [

	^ self commands
		detect: [:c | c isInsert]
		ifFound: [:c | c hasHorizontalLayout]
		ifNone: [false]
]

{ #category : #'insert commands' }
SBCombinedCommand >> hasSamePositionAs: aCommand [

	aCommand class = self class ifFalse: [^ false].
	
	self commands
		with: aCommand commands
		do: [:a :b | (a hasSamePositionAs: b) ifFalse: [^ false]].
	^ true
]

{ #category : #'insert commands' }
SBCombinedCommand >> insertIndex [

	^ self commands detect: [:c | c isInsert] ifFound: [:c | c insertIndex] ifNone: [nil]
]

{ #category : #'insert commands' }
SBCombinedCommand >> morphs [

	^ self commands detect: [:c | c respondsTo: #morphs] ifFound: [:c | c morphs] ifNone: [nil]
]

{ #category : #apply }
SBCombinedCommand >> postDo [

	commands do: #postDo
]

{ #category : #apply }
SBCombinedCommand >> preDo [

	^ commands do: #preDo
]

{ #category : #accessing }
SBCombinedCommand >> previousSelection [

	^ previousSelection ifNil: [self commands first previousSelection]
]

{ #category : #'insert commands' }
SBCombinedCommand >> secondaryInsertPosition [

	^ self commands anySatisfy: [:command | command secondaryInsertPosition]
]

{ #category : #apply }
SBCombinedCommand >> selectAfter [

	^ selectAfter ifNil: [self commands last selectAfter]
]

{ #category : #accessing }
SBCombinedCommand >> setArtefactFrom [

	^ nil
]

{ #category : #accessing }
SBCombinedCommand >> shouldMergeWithNext [

	^ self commands last shouldMergeWithNext
]

{ #category : #accessing }
SBCombinedCommand >> shouldMergeWithNext: aBoolean [

	self commands last shouldMergeWithNext: aBoolean
]

{ #category : #accessing }
SBCombinedCommand >> title [

	^ self commands first title
]

{ #category : #apply }
SBCombinedCommand >> undo [

	self commands allButFirst reverseDo: #undo.
	^ self commands first undo
]

{ #category : #testing }
SBCombinedCommand >> valid [

	^ commands notEmpty
]
