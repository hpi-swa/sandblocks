Class {
	#name : #SBStString,
	#superclass : #SBStLiteral,
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #'as yet unclassified' }
SBStString >> absorbsInput: anEvent [
	" for the first cr, require cmd to be pressed "

	(anEvent keyCharacter = Character cr and: [self contents lineCount = 1 and: [anEvent commandKeyPressed not]]) ifTrue: [^ false].
	
	^ SBGrammarHandler eventValidForString: anEvent
]

{ #category : #'as yet unclassified' }
SBStString >> guessedClass [

	^ String
]

{ #category : #'as yet unclassified' }
SBStString >> initialize [

	super initialize.
	
	text maxWidth: 500
]

{ #category : #'as yet unclassified' }
SBStString >> isStringBlock [

	^ true
]

{ #category : #'as yet unclassified' }
SBStString >> keyStroke: anEvent [

	(anEvent keyCharacter = $v and: [anEvent commandKeyPressed]) ifTrue: [
		^ text insertString: Clipboard clipboardText].
	
	(anEvent keyCharacter = Character backspace and: [self contents isEmpty]) ifTrue: [
		^ self replaceWithUnknown].
	
	self acceptInputEvent: anEvent
]

{ #category : #'as yet unclassified' }
SBStString >> oneCharLong [

	^ self contents size = 1
]

{ #category : #'as yet unclassified' }
SBStString >> pasteString [
	<inputAction>
	
	self currentTextMorph insertString: Clipboard clipboardText
]

{ #category : #'as yet unclassified' }
SBStString >> printOn: aStream [

	aStream nextPutAll: 'string '.
	aStream nextPutAll: (self contents truncateWithElipsisTo: 20)
]

{ #category : #'as yet unclassified' }
SBStString >> splitStringAtCursor [
	<inputAction>

	self sandblockEditor do: (SBReplaceCommand new
		target: self;
		replacer: (SBStMessageSend new
			receiver: (SBStString new contents: text contentsBeforeCursor)
			selector: #,
			arguments: {SBStString new contents: text contentsAfterCursor}))
]

{ #category : #'as yet unclassified' }
SBStString >> symbols [

	^ self colorPolicy symbolsForString: self
]

{ #category : #'as yet unclassified' }
SBStString >> textMorphClass [

	^ SBMultilineOwnTextMorph
]

{ #category : #'as yet unclassified' }
SBStString >> typeNewLine [
	<inputAction>
	
	self currentTextMorph insertString: String cr
]

{ #category : #'as yet unclassified' }
SBStString >> useAsStCharacter [
	<action>
	<actionValidIf: #oneCharLong>

	self sandblockEditor do: (SBReplaceCommand new
		target: self;
		replacer: (SBStCharacter new contents: self contents))
]

{ #category : #'as yet unclassified' }
SBStString >> writeSourceOn: aStream [

	self contents asString storeOn: aStream
]
