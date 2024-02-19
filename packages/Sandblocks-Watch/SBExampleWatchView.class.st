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
SBExampleWatchView >> reportValues: aCollectionOfWatchValues sized: aMorphResizer [

	aCollectionOfWatchValues do: [:anObject | self addValue: anObject sized: aMorphResizer].
	
	updateScheduled := true
]

{ #category : #accessing }
SBExampleWatchView >> savingCount [

	"Any value < 1 will result in saving all reported values"
	"Save all values"
	^ -1
]

{ #category : #display }
SBExampleWatchView >> updateDisplay [

	super updateDisplay.
	self count: (watchValues size) asString.
]
