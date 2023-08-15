Class {
	#name : #SBWatchValueBlock,
	#superclass : #SBBlock,
	#instVars : [
		'watchValue'
	],
	#category : #'Sandblocks-Babylonian'
}

{ #category : #'as yet unclassified' }
SBWatchValueBlock class >> registerShortcuts: aProvider [

	aProvider registerShortcut: Character cr do: #exploreValue.
	aProvider cmdShortcut: $i do: #exploreValue.
	
	
]

{ #category : #accessing }
SBWatchValueBlock >> exploreValue [
<action>

	self watchValue watchedValue explore
]

{ #category : #accessing }
SBWatchValueBlock >> watchValue [

	^ watchValue ifNil: [watchValue := SBWatchValue new] 
]

{ #category : #accessing }
SBWatchValueBlock >> watchValue: aSBWatchValue [

	watchValue := aSBWatchValue
]
