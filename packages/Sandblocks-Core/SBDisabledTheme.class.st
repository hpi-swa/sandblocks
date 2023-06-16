Class {
	#name : #SBDisabledTheme,
	#superclass : #SBNoColorPolicy,
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBDisabledTheme >> base [

	^ Color gray: 0.5
]

{ #category : #'as yet unclassified' }
SBDisabledTheme >> defaultEmphasis [

	^ TextEmphasis italic
]
