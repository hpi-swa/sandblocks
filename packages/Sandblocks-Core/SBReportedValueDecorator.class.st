Class {
	#name : #SBReportedValueDecorator,
	#superclass : #SBBlockDecorator,
	#instVars : [
		'label',
		'shown',
		'indicator'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBReportedValueDecorator >> attached: aMorph [

	super attached: aMorph.
	
	(self installEventBroadcasterFor: aMorph)
		when: #mouseLeave send: #mouseLeave: to: self;
		when: #mouseMove send: #mouseMove: to: self;
		when: #mouseDown send: #startDrag: to: self
]

{ #category : #'as yet unclassified' }
SBReportedValueDecorator >> detached: aMorph [

	self uninstallEventBroadcaster.
	super detached: aMorph
]

{ #category : #'as yet unclassified' }
SBReportedValueDecorator >> flash [

	self showLabel.
	self morph addAlarm: #forwardAlarm:to: withArguments: {#hideLabel. self} after: 2000
]

{ #category : #'as yet unclassified' }
SBReportedValueDecorator >> hideLabel [

	indicator ifNotNil: #delete.
	indicator := nil
]

{ #category : #'as yet unclassified' }
SBReportedValueDecorator >> indicatorBorderWidth [

	^ 3
]

{ #category : #'as yet unclassified' }
SBReportedValueDecorator >> initialize [

	super initialize.
	
	shown := false
]

{ #category : #'as yet unclassified' }
SBReportedValueDecorator >> label [

	^ label isBlock ifTrue: [label value] ifFalse: [label]
]

{ #category : #'as yet unclassified' }
SBReportedValueDecorator >> label: aString [

	label := aString
]

{ #category : #'as yet unclassified' }
SBReportedValueDecorator >> mouseLeave: anEvent [

	self hideLabel
]

{ #category : #'as yet unclassified' }
SBReportedValueDecorator >> mouseMove: anEvent [

	((self morph morphsAt: anEvent position) allSatisfy: [:m |
		m = self morph or: [
			m isSandblock not or: [
				SBToggledCode comment: 'Not nice to encode this here, find a good property' active: 1 do: {[m isMessagePart]}]]]) ifTrue: [self showLabel] ifFalse: [self hideLabel]
]

{ #category : #'as yet unclassified' }
SBReportedValueDecorator >> showLabel [

	| labelMorph |
	labelMorph := Morph new
		addMorph: (StringMorph new
			contents: (self label truncateTo: 100);
			yourself);
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		color: Color yellow;
		layoutInset: 4 withScalingFactor;
		fullBounds;
		yourself.
	indicator ifNotNil: #delete.
	indicator := Morph new
		lock;
		addMorphBack: labelMorph;
		addMorphBack: (Morph new
			color: (TranslucentColor r: 1 g: 1 b: 1 alpha: 0.176);
			borderStyle: (BorderStyle width: self indicatorBorderWidth color: Color yellow);
			extent: self morph extent + (self indicatorBorderWidth * 2);
			yourself);
		bounds: ((self morph boundsInWorld outsetBy: self indicatorBorderWidth) translateBy: 0 @ labelMorph height negated);
		openInWorld;
		color: Color transparent;
		cellPositioning: #topLeft;
		changeTableLayout;
		listDirection: #topToBottom;
		yourself
]

{ #category : #'as yet unclassified' }
SBReportedValueDecorator >> startDrag: anEvent [

	self hideLabel
]
