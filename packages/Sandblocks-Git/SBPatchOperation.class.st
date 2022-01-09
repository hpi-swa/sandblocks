Class {
	#name : #SBPatchOperation,
	#superclass : #SBBlock,
	#instVars : [
		'operation'
	],
	#category : #'Sandblocks-Git'
}

{ #category : #'as yet unclassified' }
SBPatchOperation >> browse [
	<action>

	self object browse
]

{ #category : #'as yet unclassified' }
SBPatchOperation >> diff: aLeftTree and: aRightTree [

	| m l1 l2 minHeight |
	minHeight := 2.
	m := Set new.
	l1 := Heap sortBlock: [:n1 :n2 | (self height: n1) < (self height: n2)].
	l2 := Heap sortBlock: [:n1 :n2 | (self height: n1) < (self height: n2)].
	
	l1 add: aLeftTree.
	l2 add: aRightTree.
	
	
	
]

{ #category : #'as yet unclassified' }
SBPatchOperation >> discardChange [
	<action>

	| loader |
	loader := MCPackageLoader new.
	operation inverse applyTo: loader.
	loader load.
	
	self parentSandblock rebuild
]

{ #category : #'as yet unclassified' }
SBPatchOperation >> doubleClick: evt [

	self openDiff
]

{ #category : #'as yet unclassified' }
SBPatchOperation >> dragTarget [

	^ self object asSandblock
]

{ #category : #'as yet unclassified' }
SBPatchOperation >> height: aNode [

	aNode childSandblocks ifEmpty: [^ 1].
	^ (aNode childSandblocks collect: [:child | (self height: child) + 1]) max
]

{ #category : #'as yet unclassified' }
SBPatchOperation >> initialize [

	super initialize.
	
	self
		changeTableLayout;
		cellGap: 4;
		layoutInset: 2;
		listDirection: #leftToRight;
		hResizing: #spaceFill;
		vResizing: #shrinkWrap
]

{ #category : #'as yet unclassified' }
SBPatchOperation >> object [

	| selector |
	selector := operation definition selector.
	
	operation isClassPatch ifTrue: [^ operation targetClass].
	
	^ (operation targetClass includesSelector: selector)
		ifTrue: [operation targetClass >> selector]
		ifFalse: [operation sourceText string parseAsMethodFor: operation targetClass]
]

{ #category : #'as yet unclassified' }
SBPatchOperation >> openDiff [
	<action>

	self sandblockEditor openMorphInView: (operation isModification
		ifTrue: [
			SBTextBubble multiLine contents: (TextDiffBuilder
				buildDisplayPatchFrom: operation obsoletion source
				to: operation modification source
				inClass: operation targetClass
				prettyDiffs: false)]
		ifFalse: [(operation sourceString string parseAsMethodFor: operation targetClass) asSandblock])
]

{ #category : #'as yet unclassified' }
SBPatchOperation >> operation: anOperation [

	self
		example: [SBPatchOperation new]
		args: [
			{
				MCAddition of: (MCMethodDefinition
					className: 'SBBlock'
					selector: 'hello'
					category: 'unclass'
					timeStamp: nil
					source: 'hello hello')}]
		label: 'example'.
	operation := anOperation.
	
	anOperation isAddition ifTrue: [self addMorphBack: (SBIcon iconPlus color: (Color r: 0.149 g: 0.498 b: 0.6))].
	anOperation isRemoval ifTrue: [self addMorphBack: (SBIcon iconMinus color: (Color r: 0.639 g: 0.082 b: 0.082))].
	anOperation isModification ifTrue: [self addMorphBack: (SBIcon iconEdit color: (Color r: 0.474 g: 0.369 b: 0.149))].
	
	self addMorphBack: (SBStringMorph new contents: (anOperation isClassPatch
		ifTrue: ['(class definition)']
		ifFalse: [anOperation definition selector]))
]
