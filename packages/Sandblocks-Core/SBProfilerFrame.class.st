Class {
	#name : #SBProfilerFrame,
	#superclass : #SBBlock,
	#instVars : [
		'tally'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBProfilerFrame >> drawnColor [

	^ tally method methodClass sandblockColor
]

{ #category : #'as yet unclassified' }
SBProfilerFrame >> flushLayoutCache [

	
]

{ #category : #'as yet unclassified' }
SBProfilerFrame >> initialize [

	super initialize.
	
	self
		hResizing: #spaceFill;
		vResizing: #spaceFill;
		height: self fontToUse height;
		layoutPolicy: self
]

{ #category : #'as yet unclassified' }
SBProfilerFrame >> layout: aMorph in: aRectangle [

	| x fontHeight |
	fontHeight := self fontToUse height.
	
	aMorph firstSubmorph
		layoutInBounds: (aRectangle left @ (aRectangle top + (aRectangle height - fontHeight)) extent: aRectangle width @ fontHeight)
		positioning: #topLeft.
	
	x := aRectangle left.
	aMorph submorphs allButFirstDo: [:morph | | width |
		width := ((aRectangle width * morph tally tally) / aMorph tally tally) truncated.
		morph
			layoutInBounds: (x @ aRectangle top extent: (width max: 0) @ (aRectangle height - fontHeight))
			positioning: #bottomLeft.
		x := x + width]
]

{ #category : #'as yet unclassified' }
SBProfilerFrame >> layoutInset [

	^ 0
]

{ #category : #'as yet unclassified' }
SBProfilerFrame >> minExtentOf: aMorph in: aRectangle [

	aMorph submorphCount = 1 ifTrue: [^ 0 @ aMorph fontToUse height].
	
	^ 0 @ (aMorph fontToUse height + (aMorph submorphs viewAllButFirst inject: 0 into: [:max :morph | morph minExtent y max: max]))
]

{ #category : #'as yet unclassified' }
SBProfilerFrame >> object [

	^ tally
]

{ #category : #'as yet unclassified' }
SBProfilerFrame >> tally [

	^ tally
]

{ #category : #'as yet unclassified' }
SBProfilerFrame >> tally: aTally total: total totalTime: totalTime [

	| percentage label |
	tally := aTally.
	percentage := (tally tally asFloat / total) * 100.0.
	label := String streamContents: [:s |
		s
			nextPutAll: (percentage printShowingDecimalPlaces: 1);
			nextPutAll: '% {';
			print: ((percentage * totalTime) / 100) rounded;
			nextPutAll: 'ms} '.
		tally receivers
			ifNil: [s nextPutAll: 'primitives']
			ifNotNil: [ | selector class className |
				selector := tally method selector.
				class := tally method methodClass.
				className := class name.
				tally blockNesting > 0 ifTrue: [
					s
						next: tally blockNesting put: $[;
						next: tally blockNesting put: $];
						space].
				s
					nextPutAll: class name;
					nextPutAll: (class = tally class ifTrue: ['>>'] ifFalse: [('(', class name), ')>>']);
					nextPutAll: selector;
					cr]].
	
	"self addMorphBack: (SBStringMorph new contents: label)."
	self balloonText: label.
	self addMorphBack: (Morph new extent: 1 @ 1).
	
	(tally tally / total) > 0.6 ifTrue: [
		tally receivers do: [:childTally |
			self addMorphBack: (SBProfilerFrame new tally: childTally total: total totalTime: totalTime)]]
]
