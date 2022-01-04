Class {
	#name : #SBSolarizedTheme,
	#superclass : #SBNoColorPolicy,
	#category : #'Sandblocks-Core'
}

{ #category : #colors }
SBSolarizedTheme >> background [

	^ Color r: 0.992 g: 0.965 b: 0.891
]

{ #category : #colors }
SBSolarizedTheme >> builtIn [

	^ Color r: 0.796 g: 0.294 b: 0.086
]

{ #category : #colors }
SBSolarizedTheme >> darkerBackground [

	^ Color fromString: 'eee8d5'
]

{ #category : #colors }
SBSolarizedTheme >> default [

	^ Color r: 0.0 g: 0.169 b: 0.212
]

{ #category : #colors }
SBSolarizedTheme >> defaultInverted [

	^ Color r: 1 g: 0.999 b: 0.995
]

{ #category : #colors }
SBSolarizedTheme >> defaultLight [

	^ Color r: 0.514 g: 0.581 b: 0.588
]

{ #category : #colors }
SBSolarizedTheme >> editor [

	^ self darkerBackground
]

{ #category : #colors }
SBSolarizedTheme >> identifier [

	^ Color r: 0.149 g: 0.545 b: 0.823
]

{ #category : #colors }
SBSolarizedTheme >> important [

	^ Color r: 0.863 g: 0.196 b: 0.185
]

{ #category : #colors }
SBSolarizedTheme >> keyword [

	^ Color fromString: '6c71c4'
]

{ #category : #colors }
SBSolarizedTheme >> literal [

	^ Color r: 0.164 g: 0.631 b: 0.596
]

{ #category : #'as yet unclassified' }
SBSolarizedTheme >> toolColor [

	^ Color fromString: '002b36'
]
