Class {
	#name : #SBMetaUnknown,
	#superclass : #SBUnknown,
	#instVars : [
		'objectInterfaces',
		'factory'
	],
	#category : #'Sandblocks-TreeSitter'
}

{ #category : #'as yet unclassified' }
SBMetaUnknown >> contents: aString [

	self currentTextMorph contents: aString
]

{ #category : #'as yet unclassified' }
SBMetaUnknown >> factory: aFactory [

	factory := aFactory
]

{ #category : #'as yet unclassified' }
SBMetaUnknown >> keyStroke: anEvent [

	self currentTextMorph keyStroke: anEvent.
	
	factory unambiguousRule: objectInterfaces for: self contents do: [:rule :keyWasTaken | | new editor |
		new := factory build: rule.
		editor := self sandblockEditor.
		keyWasTaken ifFalse: [
			SBToggledCode
				comment: ''
				active: 1
				do: {[new contents: self contents]. [editor selection keyStroke: anEvent]}].
		new startInputCommand
			ifNil: [
				editor
					do: (SBReplaceCommand new
						target: self;
						replacer: new);
					endInput.
				new startNextInput]
			ifNotNil: [
				self replaceBy: new.
				editor replaceInput: new]]
]

{ #category : #'as yet unclassified' }
SBMetaUnknown >> objectInterfaces [

	^ objectInterfaces
]

{ #category : #'as yet unclassified' }
SBMetaUnknown >> objectInterfaces: aCollection [

	objectInterfaces := aCollection
]

{ #category : #'as yet unclassified' }
SBMetaUnknown >> printOn: aStream [

	aStream
		nextPutAll: 'unknown ';
		nextPutAll: (self objectInterfaces isString
			ifTrue: [self objectInterfaces]
			ifFalse: [self objectInterfaces joinSeparatedBy: ', '])
]
