Class {
	#name : #SBUnknown,
	#superclass : #SBLiteral,
	#category : 'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBUnknown >> acceptCharacter: aCharacter [

	SBSmalltalkGrammarHandler new perform: aCharacter for: self empty: true
]

{ #category : #'as yet unclassified' }
SBUnknown >> contents: aString [

	aString ifNotEmpty: [ | editor |
		editor := self sandblockEditor.
		self acceptCharacter: aString first.
		editor currentInput contents: editor currentInput contents, aString allButFirst]
]

{ #category : #'as yet unclassified' }
SBUnknown >> deleteBeforeCursor [
	<inputAction>
	
	self tryDelete
]

{ #category : #'as yet unclassified' }
SBUnknown >> doReplaceBy: aMorph [

	self stopEditing.
	self replaceBy: aMorph.
	
	aMorph moveCursorTo: 9e8.
	aMorph sandblockEditor replaceInput: aMorph
]

{ #category : #'as yet unclassified' }
SBUnknown >> doWrap: aBlock with: aNode [

	self sandblockEditor
		endInput;
		do: ((SBWrapCommand newFor: self containingArtefact)
			inner: self;
			outer: aNode;
			shouldMergeWithNext: true;
			wrap: aBlock);
		startInput: self at: 0 replacingContents: false
]

{ #category : #'as yet unclassified' }
SBUnknown >> emptyLine [
	<action>
	<actionValidIf: #isStatement>
	
	self sandblockEditor do: ((SBReplaceCommand newFor: self containingArtefact)
		target: self;
		replacer: SBEmptyLine new)
]

{ #category : #'as yet unclassified' }
SBUnknown >> isUnknown [

	^ true
]

{ #category : #'as yet unclassified' }
SBUnknown >> keyStroke: anEvent [

	self acceptCharacter: anEvent keyCharacter
]

{ #category : #'as yet unclassified' }
SBUnknown >> printOn: aStream [

	aStream nextPutAll: 'unknown'
]

{ #category : #'as yet unclassified' }
SBUnknown >> replaceWithPragma [

	| pragma |
	pragma := SBPragma new.
	self stopEditing.
	self sandblockEditor do: ((SBReplaceCommand newFor: self containingArtefact)
		target: self;
		replacer: pragma;
		shouldMergeWithNext: true).
	^ pragma sandblockEditor startInput: pragma at: 1 replacingContents: true
]

{ #category : #'as yet unclassified' }
SBUnknown >> symbols [

	^ self colorPolicy symbolsForUnknown: self
]

{ #category : #'as yet unclassified' }
SBUnknown >> tryDelete [

	| editor p |
	p := self previousBlock.
	editor := self sandblockEditor.
	
	self deleteBlock.
	editor startInput: p at: 9e8 replacingContents: false
]

{ #category : #'as yet unclassified' }
SBUnknown >> valid [

	^ false
]

{ #category : #'as yet unclassified' }
SBUnknown >> writeSourceOn: aStream [

	"self error: 'source is not valid because it contains non-filled values'"
]
