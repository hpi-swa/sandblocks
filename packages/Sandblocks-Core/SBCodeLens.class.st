"
A SBCodeLens displays a method and supports collapsing it to just the header or reducing it to just a focused expression with a fadeout around it for context.
"
Class {
	#name : #SBCodeLens,
	#superclass : #SBCodeContainer,
	#instVars : [
		'scroll',
		'label',
		'mode'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBCodeLens class >> forContext: aCodeContext [

	^ self forMethod: aCodeContext method pc: aCodeContext pc
]

{ #category : #'as yet unclassified' }
SBCodeLens class >> forMethod: aCompiledMethod pc: aNumber [

	| methodBlock |
	methodBlock := aCompiledMethod asSandblock.
	^ self new
		method: methodBlock;
		fullBounds;
		focus: (methodBlock blockForPC: aNumber);
		yourself
]

{ #category : #'as yet unclassified' }
SBCodeLens class >> forMethod: aCompiledMethod selector: aSymbol [

	| methodBlock |
	methodBlock := aCompiledMethod asSandblock.
	^ self new
		method: methodBlock;
		fullBounds;
		focus: (methodBlock blockForSelector: aSymbol);
		yourself
]

{ #category : #helper }
SBCodeLens >> applyMode: aSymbol [

	mode  = aSymbol ifTrue: [^ self].
	mode := aSymbol.
	
	self method collapsed: aSymbol = #collapse.
	scroll hResizing: (aSymbol = #collapse ifTrue: [#shrinkWrap] ifFalse: [#spaceFill]).
	
	aSymbol = #focus
		ifTrue: [ | focus |
			focus := self findMarkedBlock.
			scroll
				offset: 0 @ (focus top - self fadeSize max: 0);
				layoutPolicy: nil.
			self
				vResizing: #rigid;
				height: (focus height + (self fadeSize * 2) min: (scroll firstSubmorph height - scroll offset y)) + (self layoutInset * 2);
				width: scroll firstSubmorph width + (self layoutInset * 2)]
		ifFalse: [
			self vResizing: #shrinkWrap.
			scroll
				offset: 0 @ 0;
				layoutPolicy: TableLayout new]
]

{ #category : #accessing }
SBCodeLens >> childSandblocksDo: aBlock [

	aBlock value: scroll firstSubmorph
]

{ #category : #menus }
SBCodeLens >> collapse [

	self applyMode: #focus
]

{ #category : #callbacks }
SBCodeLens >> collapseCompletely [

	self applyMode: #collapse
]

{ #category : #drawing }
SBCodeLens >> drawSubmorphsOn: aCanvas [

	| bottomOrigin fadeExtent fill |
	super drawSubmorphsOn: aCanvas.
	
	scroll visible ifFalse: [^ self].
	
	fadeExtent := scroll width @ self fadeSize.
	bottomOrigin := scroll bottomLeft - (0 @ self fadeSize).
	
	scroll offset y > 0 ifTrue: [
		fill := (GradientFillStyle ramp: {0.0 -> Color white. 0.3 -> (Color white alpha: 0.5). 1.0 -> (Color white alpha: 0.005)})
			origin: scroll topLeft; direction: 0 @ self fadeSize.
		aCanvas fillRectangle: (scroll topLeft extent: fadeExtent) fillStyle: fill.
		aCanvas drawString: (self method methodClass name, ' >> ', self method selector) at: scroll position + (8 @ 0 * self scalingFactor)].
	
	scroll bottom + 10 < scroll submorphBounds bottom ifTrue: [
		fill := (GradientFillStyle ramp: {0.0 -> (Color white alpha: 0.005). 0.5 -> (Color white alpha: 0.5). 0.8 -> Color white})
			origin: bottomOrigin; direction: 0 @ self fadeSize.
		aCanvas fillRectangle: (bottomOrigin extent: fadeExtent) fillStyle: fill]
]

{ #category : #callbacks }
SBCodeLens >> expand [

	self applyMode: #expand
]

{ #category : #constants }
SBCodeLens >> fadeSize [

	^ 80
]

{ #category : #helper }
SBCodeLens >> findMarkedBlock [

	^ self findDeepSubmorphThat: [:morph | morph isSandblock and: [morph hasDecorator: SBMarkedDecorator]] ifAbsent: [nil]
]

{ #category : #callbacks }
SBCodeLens >> focus: aBlock [

	aBlock
		ifNotNil: [
			aBlock attachDecorator: SBMarkedDecorator new.
			self applyMode: #focus]
		ifNil: [self applyMode: #expand]
]

{ #category : #initialization }
SBCodeLens >> initialize [

	super initialize.
	
	self
		layoutInset: 0;
		changeTableLayout;
		vResizing: #rigid;
		hResizing: #shrinkWrap;
		"addMorphBack: (label := SBStringMorph new
			hResizing: #spaceFill;
			vResizing: #shrinkWrap;
			emphasis: TextEmphasis bold emphasisCode);
		"addMorphBack: (scroll := TransformMorph new
			color: Color white;
			layoutInset: 2 * self scalingFactor;
			hResizing: #spaceFill;
			vResizing: #spaceFill;
			yourself)
]

{ #category : #testing }
SBCodeLens >> isExpanded [

	^ scroll visible
]

{ #category : #accessing }
SBCodeLens >> method [

	^ scroll firstSubmorph
]

{ #category : #accessing }
SBCodeLens >> method: aMethod [

	scroll addMorphBack: aMethod.
	"label contents: aMethod methodClass asString, '>>', aMethod selector asString"
]

{ #category : #callbacks }
SBCodeLens >> wasSelected [

	self isExpanded ifTrue: [self collapseCompletely] ifFalse: [self expand]
]
