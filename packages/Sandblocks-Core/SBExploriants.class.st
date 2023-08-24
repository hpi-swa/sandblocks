Class {
	#name : #SBExploriants,
	#superclass : #SBBlock,
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBExploriants class >> openIn: anEditor [

	(self new visualize) openIn: anEditor
]

{ #category : #'as yet unclassified' }
SBExploriants >> allMethodsContainingVariants [

	^ ((self systemNavigation allCallsOn: SBVariant matchingSelector) 
		reject: [:aMethodReference | aMethodReference actualClass = SBVariant class])
		collect: #compiledMethod
]

{ #category : #'as yet unclassified' }
SBExploriants >> initialize [

	super initialize.
	
	self
		attachDecorator: SBMoveDecorator new;
		changeTableLayout;
		listDirection: #topToBottom;
		layoutInset: 8;
		cellGap: 16;
		cellInset: 10;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap
]

{ #category : #'as yet unclassified' }
SBExploriants >> openIn: anEditor [

	anEditor openMorphInView: self
]

{ #category : #'as yet unclassified' }
SBExploriants >> visualize [

	self allMethodsContainingVariants 
		collect: #asSandblock
		thenDo: [:aSBStMethod | 
			self addMorphBack: aSBStMethod methodHeader copy.
			aSBStMethod containedVariants do: [:aSBVariant | self addMorphBack: (SBVariantProxy for: aSBVariant)].
			self addMorphBack: (LineMorph from: 0@0 to: 50@0 color: Color black width: 2)].
	
		
	
]
