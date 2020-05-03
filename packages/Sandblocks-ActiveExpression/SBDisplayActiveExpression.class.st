"
A SBDisplayActiveExpression is used by SBWatch when an active expression is observed through reportValue:. It will keep a reference to that active expression and subscribe to listen to its changes to then kickoff the remaining tool UI.
"
Class {
	#name : #SBDisplayActiveExpression,
	#superclass : #Morph,
	#instVars : [
		'expressions',
		'marbles',
		'invocations'
	],
	#category : #'Sandblocks-ActiveExpression'
}

{ #category : #'as yet unclassified' }
SBDisplayActiveExpression class >> matches: anObject [

	^ anObject class = SynchronousActiveExpression or: [anObject class = SBSynchronousActiveExpression]
]

{ #category : #colors }
SBDisplayActiveExpression >> dark: aBoolean [

]

{ #category : #'example callbacks' }
SBDisplayActiveExpression >> exampleFinished: aSBExample [ 

	marbles exampleFinished: aSBExample.
	invocations exampleFinished: aSBExample
]

{ #category : #'example callbacks' }
SBDisplayActiveExpression >> exampleStarting: anExample [

	invocations exampleStarting: anExample.
	marbles exampleStarting: anExample.
	
	expressions keysAndValuesDo: [:expression :callback | expression afterInvokeDo: nil].
	expressions removeAll
]

{ #category : #initialization }
SBDisplayActiveExpression >> initialize [

	super initialize.
	
	expressions := OrderedDictionary new.
	invocations := SBAEInvocations new
		when: #showSubscribers send: #showSubscribersOf: to: self;
		yourself.
	marbles := SBAEMarbles new
		when: #selectExpression send: #selectExpression: to: invocations;
		when: #selectSubject send: #selectSubject: to: invocations;
		yourself.
	
	self
		color: Color transparent;
		changeTableLayout;
		cellGap: 8 withScalingFactor;
		hResizing: #spaceFill;
		vResizing: #shrinkWrap;
		addMorphBack: marbles;
		addMorphBack: (Morph new
			color: Color lightGray;
			hResizing: #spaceFill;
			extent: (0 @ 1) withScalingFactor;
			yourself);
		addMorphBack: invocations
]

{ #category : #callbacks }
SBDisplayActiveExpression >> reportValue: anObject [

	| callback subject expr |
	self flag: #fixme. " more robust option to find original context? "
	subject := thisContext sender sender sender sender receiver.
	expr := anObject.
	anObject subject: subject.
	
	expressions at: anObject put: (callback := [:newValue :sideEffects |
		marbles addMarble: subject value: newValue expression: expr.
		invocations addInvocation: thisContext value: newValue from: subject expression: expr]).
	
	anObject afterInvokeDo: callback.
	invocations addExpression: anObject
]

{ #category : #callbacks }
SBDisplayActiveExpression >> showSubscribersOf: anExpression [

	| lenses |
	lenses := Array streamContents: [:stream |
		anExpression callbacks do: [:cb | cb ~= (expressions at: anExpression) ifTrue: [
			" block declare comes 4 bytes before block's startpc "
			stream nextPut: (SBCodeLens forContext: ((SBCodeContext for: cb outerContext) pc: cb startpc - 4))]]].
	lenses ifNotEmpty: [
		SBCodeAccordion new
			addAllMorphs: lenses;
			openNear: self containingSandblock;
			select]
]
