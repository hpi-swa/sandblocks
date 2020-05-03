"
A SBAEInvocationAggregate collects all necessary information for the UI to display an invocation of an active expression. It optionally supports aggregating similar invocations by incrementing its count.
"
Class {
	#name : #SBAEInvocationAggregate,
	#superclass : #Morph,
	#instVars : [
		'stack',
		'count',
		'currentStackIndex',
		'image',
		'countLabel',
		'resultLabel',
		'subject',
		'lastSideEffects',
		'sideEffectsIcon'
	],
	#category : #'Sandblocks-ActiveExpression'
}

{ #category : #accessing }
SBAEInvocationAggregate >> addInvocation: aResultString [

	self count: self count + 1.
	resultLabel contents: '--> ', aResultString
]

{ #category : #accessing }
SBAEInvocationAggregate >> count [

	^ count
]

{ #category : #accessing }
SBAEInvocationAggregate >> count: aNumber [

	count := aNumber.
	count > 1 ifTrue: [
		countLabel disableLayout: false; visible: true; contents: aNumber asString]
]

{ #category : #initialization }
SBAEInvocationAggregate >> initialize [

	super initialize.
	
	self
		count: 0;
		color: Color transparent;
		layoutPolicy: SBVerticalLayout new;
		listDirection: #leftToRight;
		cellGap: 4 withScalingFactor;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		addMorphBack: (SBRow new
			addMorphBack: (image := ImageMorph new
				on: #click send: #openStack to: self;
				yourself);
			addMorphBack: (countLabel := SBBadge new
				disableLayout: true;
				visible: false;
				yourself);
			addMorphBack: (resultLabel := SBStringMorph new);
			yourself)
]

{ #category : #accessing }
SBAEInvocationAggregate >> lastSideEffects [

	^ lastSideEffects
]

{ #category : #accessing }
SBAEInvocationAggregate >> lastSideEffects: aCollection [

	lastSideEffects := aCollection.
	
	aCollection ifNotEmpty: [
		self addMorphBack: (SBStringMorph new
			contents: '      SIDE EFFECTS:';
			emphasis: TextEmphasis bold emphasisCode;
			yourself)].
	
	aCollection do: [:sideEffect |
		self addMorphBack: (SBStringMorph new
			contents: ('      ({1}) {2} := {3}' format: {sideEffect second printStringLimitedTo: 40. sideEffect first. sideEffect third});
			on: #click send: #openSideEffectStack:event:morph: to: self withValue: sideEffect fourth;
			onHoverHighlight: sideEffect second labeled: sideEffect third;
			yourself)]
]

{ #category : #opening }
SBAEInvocationAggregate >> openSideEffectStack: aCollection event: anEvent morph: aMorph [

	(SBCodeAccordion newForStack: aCollection) openNear: self containingSandblock
]

{ #category : #opening }
SBAEInvocationAggregate >> openStack [

	(SBCodeAccordion newForStack: self stack) openNear: self containingSandblock
]

{ #category : #helper }
SBAEInvocationAggregate >> sameLocation: anInvocation [

	^ self stack hasEqualElements: anInvocation stack
]

{ #category : #accessing }
SBAEInvocationAggregate >> stack [

	^ stack
]

{ #category : #accessing }
SBAEInvocationAggregate >> stack: anObject [

	stack := anObject.
	
	self stackImageIndex: 1
]

{ #category : #accessing }
SBAEInvocationAggregate >> stackImageIndex: aNumber [

	aNumber = currentStackIndex ifTrue: [^ self].
	
	image balloonText: ((stack collectWithIndex: [:frame :index |
		index = aNumber
			ifTrue: [frame stringRepresentation asText allBold]
			ifFalse: [frame stringRepresentation asText]]) fold: [:a :b | a, String cr, b]).
	
	currentStackIndex := aNumber.
	image image: (stack at: aNumber) imageForm
]

{ #category : #accessing }
SBAEInvocationAggregate >> subject [

	^ subject
]

{ #category : #accessing }
SBAEInvocationAggregate >> subject: anObject [

	subject := anObject
]
