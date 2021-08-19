Class {
	#name : #SBTSUnknown,
	#superclass : #SBUnknown,
	#instVars : [
		'type',
		'factory',
		'template'
	],
	#category : #'Sandblocks-TreeSitter'
}

{ #category : #'as yet unclassified' }
SBTSUnknown >> contents: aString [

	self currentTextMorph contents: aString
]

{ #category : #'as yet unclassified' }
SBTSUnknown >> cursorPositionsDo: aBlock [

	aBlock value: (SBCursorSelect new block: self).
	self startInputCommand ifNotNil: [:command |
		aBlock value: (SBCursorText new
			block: self;
			currentCommand: command)]
]

{ #category : #'as yet unclassified' }
SBTSUnknown >> factory: aFactory [

	factory := aFactory
]

{ #category : #'as yet unclassified' }
SBTSUnknown >> keyStroke: anEvent [

	| matchFullToken prefix options |
	self currentTextMorph keyStroke: anEvent.
	
	prefix := (matchFullToken := self contents last = Character space)
		ifTrue: [self contents allButLast]
		ifFalse: [self contents].
	template
		triggersFor: prefix
		matchFullToken: matchFullToken
		options: (options := SBTSPartialNode new).
	options size = 1 ifTrue: [
		self sandblockEditor do: (SBReplaceCommand new
			target: self;
			replacer: (template buildPartial: options children first with: prefix))]
]

{ #category : #'as yet unclassified' }
SBTSUnknown >> printOn: aStream [

	aStream nextPutAll: 'unknown '.
	template printTitleOn: aStream
]

{ #category : #'as yet unclassified' }
SBTSUnknown >> template: aBlock [

	template := aBlock
]

{ #category : #'as yet unclassified' }
SBTSUnknown >> type: aString factory: aFactory [

	type := aString.
	factory := aFactory
]

{ #category : #'as yet unclassified' }
SBTSUnknown >> veryDeepCopyWith: deepCopier [

	| f copy t |
	f := factory.
	t := template.
	factory := nil.
	template := nil.
	copy := super veryDeepCopyWith: deepCopier.
	factory := f.
	template := t.
	copy factory: f.
	copy template: t.
	^ copy
]
