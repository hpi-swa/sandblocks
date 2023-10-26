"
A watch display observing an example that updates itself as soon as the watched example has finished
"
Class {
	#name : #SBExampleWatchView,
	#superclass : #SBWatchView,
	#category : #'Sandblocks-Watch'
}

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
SBExampleWatchView >> reportValues: aCollectionOfObjects sized: aMorphResizer [

	aCollectionOfObjects do: [:anObject | self addValue: anObject sized: aMorphResizer].
	
	updateScheduled := true
]

{ #category : #display }
SBExampleWatchView >> updateDisplay [

	super updateDisplay.
	
	self count: (watchValues size) asString
]
