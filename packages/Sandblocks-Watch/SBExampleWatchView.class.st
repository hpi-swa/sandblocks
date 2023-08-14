"
A watch display observing an example that updates itself as soon as the watched example has finished
"
Class {
	#name : #SBExampleWatchView,
	#superclass : #SBWatchView,
	#category : #'Sandblocks-Watch'
}

{ #category : #accessing }
SBExampleWatchView >> display [

	(self submorphCount >= 2)
		ifFalse: [self addMorph: (self defaultDisplay) atIndex: 2].
	^self submorphs second
]

{ #category : #'event handling' }
SBExampleWatchView >> exampleFinished: anExample [

	self updateDisplay
]

{ #category : #'event handling' }
SBExampleWatchView >> exampleStarting: anExample [

	self clear
]

{ #category : #initialization }
SBExampleWatchView >> initialize [

	super initialize.
	
	"Example Watches clear themselves on every finished run"
	self lastSubmorph delete
]

{ #category : #accessing }
SBExampleWatchView >> reportValue: anObject [

	self addValue: anObject.
	
	updateScheduled := true
]

{ #category : #display }
SBExampleWatchView >> updateDisplay [

	super updateDisplay.
	
	count contents: (watchValues size) asString
]
