Class {
	#name : #SBASTNode,
	#superclass : #SBBlock,
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBASTNode >> acceptedRepresentation [

	^ (self parentSandblock notNil and: [self parentSandblock isASTNode]) ifTrue: [
		self parentSandblock contextAcceptedRepresentationAt: self childIndex] ifFalse: [nil]
]

{ #category : #'as yet unclassified' }
SBASTNode >> contextAcceptedRepresentationAt: aNumber [

	^ #isSmalltalkExpression
]

{ #category : #'as yet unclassified' }
SBASTNode >> handleDroppedBlock: aBlock event: anEvent [

	| replacer |
	replacer := aBlock object representationThat: (self parentSandblock contextAcceptedRepresentationAt: self childIndex).
	self sandblockEditor do: ((SBReplaceCommand newFor: self containingArtefact)
		target: self;
		replacer: replacer).
	replacer postDuplicate
]

{ #category : #shortcuts }
SBASTNode >> insertStatementAbove [

	self insertStatementAboveOrBelow: true
]

{ #category : #shortcuts }
SBASTNode >> insertStatementAboveOrBelow: anAboveBoolean [

	| currentStatement index newStatement |
	newStatement := SBUnknown new.
	[
		currentStatement := self selection containingStatement.
		index := currentStatement owner submorphIndexOf: currentStatement.
		self do: ((SBInsertCommand newFor: self selection containingArtefact)
			index: (anAboveBoolean ifTrue: [index] ifFalse: [index + 1]);
			container: currentStatement owner;
			morph: newStatement;
			shouldMergeWithNext: true;
			yourself)].
	self startInput: newStatement at: 1 replacingContents: false
]

{ #category : #shortcuts }
SBASTNode >> insertStatementBelow [

	self insertStatementAboveOrBelow: false
]

{ #category : #'as yet unclassified' }
SBASTNode >> isASTNode [

	^ true
]

{ #category : #testing }
SBASTNode >> isReturn [

	^ false
]

{ #category : #'as yet unclassified' }
SBASTNode >> object [

	^ self
]

{ #category : #shortcuts }
SBASTNode >> wrapAsArgument [

	| msg |
	msg := SBMessageSend new.
	self sandblockEditor
		do: ((SBWrapCommand newFor: self containingArtefact)
			outer: msg;
			inner: self;
			shouldMergeWithNext: true;
			wrap: [:outer :inner |
				outer receiver: SBUnknown new selector: SBMessageSend placeholderSelector arguments: {inner}];
			yourself);
		startInput: msg receiver at: 0 replacingContents: false
]

{ #category : #shortcuts }
SBASTNode >> wrapInArrayType: aSymbol [

	self sandblockEditor do: ((SBWrapCommand newFor: self containingArtefact)
		outer: SBArray new;
		inner: self;
		wrap: [:outer :inner | outer type: aSymbol contents: {inner}];
		yourself)
]

{ #category : #shortcuts }
SBASTNode >> wrapInBlock [

	self assert: self isSelected.
	self sandblockEditor doMultiSelection: [:statements |
		self flag: #todo.
		(SBWrapCommand newFor: self containingArtefact)
			outer: SBBlockBody new;
			inner: self;
			wrap: [:outer :inner | outer statements: statements];
			yourself]
]

{ #category : #shortcuts }
SBASTNode >> wrapInCascade [

	| cascade |
	cascade := SBCascade new.
	self isMessageSend ifFalse: [^ self].
	self assert: self isSelected.
	self sandblockEditor multiSelectionIsConsecutive ifFalse: [^ self].
	self sandblockEditor doMultiSelection: [:selected |
		(SBWrapConsecutiveCommand newFor: self containingArtefact)
			targets: selected;
			outer: SBCascade new;
			wrap: [:outer :inner |
				outer addMorphFront: inner first receiver.
				outer addAllMorphs: inner];
			wrapUndo: [:outer :inner |
				inner do: [:message | message receiver: outer receiver veryDeepCopy].
				outer removeAllMorphs]].
	SBToggledCode comment: '' active: 0 do: {[self sandblockEditor select: cascade]}
]

{ #category : #shortcuts }
SBASTNode >> wrapInDynamicArray [

	self wrapInArrayType: #dynamic
]

{ #category : #shortcuts }
SBASTNode >> wrapInLiteralArray [

	self wrapInArrayType: #literal
]

{ #category : #shortcuts }
SBASTNode >> wrapInMessageSend [

	self wrapInMessageSend: ''
]

{ #category : #shortcuts }
SBASTNode >> wrapInMessageSend: aString [

	| msg |
	self isExpression ifFalse: [^ self].
	msg := SBMessageSend new.
	self sandblockEditor do: ((SBWrapCommand newFor: self containingArtefact)
		outer: msg;
		inner: self;
		shouldMergeWithNext: true;
		wrap: [:outer :inner |
			outer
				receiver: inner
				selector: aString
				arguments: (aString numArgs > 0 ifTrue: [
					(1 to: aString numArgs) collect: [:i | SBUnknown new]] ifFalse: [#()])];
		yourself).
	self sandblockEditor startInput: msg at: 900000000 replacingContents: false
]

{ #category : #shortcuts }
SBASTNode >> wrapInReturn [

	self sandblockEditor do: ((SBWrapCommand newFor: self containingArtefact)
		outer: SBReturn new;
		inner: self;
		wrap: [:outer :inner | outer expression: inner];
		yourself)
]
