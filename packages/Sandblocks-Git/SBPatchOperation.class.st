Class {
	#name : #SBPatchOperation,
	#superclass : #SBBlock,
	#instVars : [
		'operation'
	],
	#category : #'Sandblocks-Git'
}

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
