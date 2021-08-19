Class {
	#name : #SBInlineBlock,
	#superclass : #Morph,
	#instVars : [
		'name'
	],
	#category : #'Sandblocks-TreeSitter'
}

{ #category : #'as yet unclassified' }
SBInlineBlock >> buildPartial: anOptions with: aString [

	^ self subclassResponsibility
]

{ #category : #'block api' }
SBInlineBlock >> colorPolicy [

	^ self containingSandblock colorPolicy
]

{ #category : #'block api' }
SBInlineBlock >> containingFloat [

	^ self containingSandblock containingFloat
]

{ #category : #'as yet unclassified' }
SBInlineBlock >> currentTextMorph [

	^ nil
]

{ #category : #'as yet unclassified' }
SBInlineBlock >> cursorPositionsDo: aBlock [

	self submorphsDo: [:m | m cursorPositionsDo: aBlock]
]

{ #category : #'as yet unclassified' }
SBInlineBlock >> deleteTargetFor: aBlock [

	^ nil
]

{ #category : #'block api' }
SBInlineBlock >> ensureVisible [

	self containingSandblock ensureVisible
]

{ #category : #geometry }
SBInlineBlock >> extent: aPoint [

	super extent: (aPoint max: 0 @ self minimumHeight)
]

{ #category : #'as yet unclassified' }
SBInlineBlock >> firstBlock [

	self allMorphsDo: [:m | m isSandblock ifTrue: [^ m]].
	^ nil
]

{ #category : #'block api' }
SBInlineBlock >> frameSize [

	^ self containingSandblock frameSize
]

{ #category : #'block api' }
SBInlineBlock >> hasHorizontalLayout [

	^ self containingSandblock hasHorizontalLayout
]

{ #category : #'initialize-release' }
SBInlineBlock >> initialize [

	super initialize.
	
	self
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		changeTableLayout;
		listDirection: #leftToRight;
		color: Color transparent;
		cellGap: 2;
		layoutInset: 2;
		cellPositioning: #center;
		extent: 0 @ 0
]

{ #category : #'as yet unclassified' }
SBInlineBlock >> isUnambiguous [

	^ self submorphs allSatisfy: [:m | m isUnambiguous]
]

{ #category : #geometry }
SBInlineBlock >> minimumHeight [

	^ TextStyle defaultFont height + 4
]

{ #category : #'as yet unclassified' }
SBInlineBlock >> name: aString [

	name := aString
]

{ #category : #'as yet unclassified' }
SBInlineBlock >> performAction: aSymbol [

	^ self containingSandblock performAction: aSymbol
]

{ #category : #'as yet unclassified' }
SBInlineBlock >> printTitleOn: aStream [

	^ self subclassResponsibility
]

{ #category : #'block api' }
SBInlineBlock >> selectionLabel [

	^ self containingSandblock selectionLabel
]

{ #category : #'as yet unclassified' }
SBInlineBlock >> title [

	^ String streamContents: [:stream | self printTitleOn: stream]
]

{ #category : #'as yet unclassified' }
SBInlineBlock >> triggersFor: aString matchFullToken: aBoolean options: anOptions [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SBInlineBlock >> veryDeepCopyWith: aCopier [

	| new oldActions |
	oldActions := self valueOfProperty: #actionMap.
	self removeProperty: #actionMap.
	new := super veryDeepCopyWith: aCopier.
	self setProperty: #actionMap toValue: oldActions.
	^ new
]

{ #category : #'block api' }
SBInlineBlock >> wasDeselected [

	
]

{ #category : #'block api' }
SBInlineBlock >> wasSelected [

	
]
