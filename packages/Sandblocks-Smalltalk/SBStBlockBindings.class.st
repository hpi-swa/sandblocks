Class {
	#name : #SBStBlockBindings,
	#superclass : #SBBlockRow,
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #'as yet unclassified' }
SBStBlockBindings >> cursorPositionsDo: aBlock shallow: aBoolean [

	self hasSubmorphs
		ifTrue: [super cursorPositionsDo: aBlock shallow: aBoolean]
		ifFalse: [ | cmd |
			cmd := SBRelInsertCommand new
				near: nil before: true in: self morph: SBStName new;
				secondaryInsertPosition: true;
				shouldMergeWithNext: true;
				title: 'insert block binding';
				yourself.
			aBlock value: (SBCursorInsert new
				command: cmd;
				before: true;
				adjacent: nil;
				container: self containingSandblock)]
]

{ #category : #'as yet unclassified' }
SBStBlockBindings >> isBlockBindings [

	^ true
]

{ #category : #'as yet unclassified' }
SBStBlockBindings >> layoutInset [

	^ self hasSubmorphs ifTrue: [2] ifFalse: [0]
]
