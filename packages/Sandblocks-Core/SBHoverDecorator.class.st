Class {
	#name : #SBHoverDecorator,
	#superclass : #SBBlockDecorator,
	#instVars : [
		'shown'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBHoverDecorator >> attached: aMorph [

	super attached: aMorph.
	
	shown := true.
	SBToggledCode comment: '' active: 0 do: {
		[
			aMorph world
				addAlarm: #startShowing
				withArguments: #()
				for: self
				at: Time millisecondClockValue + 10]}
]

{ #category : #'as yet unclassified' }
SBHoverDecorator >> color [

	^ self morph colorPolicy selectionColorForBlock: (self morph parentSandblock ifNil: [self morph])
]

{ #category : #'as yet unclassified' }
SBHoverDecorator >> detached: aMorph [

	super detached: aMorph.
	
	shown ifFalse: [aMorph world ifNotNil: [:w | w removeAlarm: #startShowing for: self]]
]

{ #category : #'as yet unclassified' }
SBHoverDecorator >> postDrawOn: aCanvas [

	(self shown and: [SBPreferences showHoverDecorator]) ifTrue: [
		aCanvas
			frameRoundRect: self morph bounds
			radius: self morph colorPolicy cornerRadius
			width: 2
			color: (self color alpha: 0.2)]
]

{ #category : #'as yet unclassified' }
SBHoverDecorator >> shown [

	^ shown ifNil: [false]
]

{ #category : #'as yet unclassified' }
SBHoverDecorator >> startShowing [

	shown := true.
	self morph changed
]
