Class {
	#name : #SBSolarizedDarkTheme,
	#superclass : #SBSolarizedTheme,
	#category : #'Sandblocks-Core'
}

{ #category : #colors }
SBSolarizedDarkTheme >> background [

	^ Color r: 0.0 g: 0.169 b: 0.212
]

{ #category : #colors }
SBSolarizedDarkTheme >> builtIn [

	^ Color r: 0.796 g: 0.294 b: 0.086
]

{ #category : #colors }
SBSolarizedDarkTheme >> dark [

	^ true
]

{ #category : #colors }
SBSolarizedDarkTheme >> darkerBackground [

	^ Color r: 0.027 g: 0.212 b: 0.259
]

{ #category : #colors }
SBSolarizedDarkTheme >> default [

	^ Color r: 0.577 g: 0.631 b: 0.631
]

{ #category : #colors }
SBSolarizedDarkTheme >> defaultInverted [

	^ Color r: 0.345 g: 0.431 b: 0.458
]

{ #category : #colors }
SBSolarizedDarkTheme >> editor [

	^ self darkerBackground
]

{ #category : #colors }
SBSolarizedDarkTheme >> identifier [

	^ Color r: 0.149 g: 0.545 b: 0.823
]

{ #category : #colors }
SBSolarizedDarkTheme >> important [

	^ Color r: 0.863 g: 0.196 b: 0.185
]

{ #category : #colors }
SBSolarizedDarkTheme >> keyword [

	^ Color fromString: '6c71c4'
]

{ #category : #colors }
SBSolarizedDarkTheme >> literal [

	^ Color r: 0.164 g: 0.631 b: 0.596
]

{ #category : #colors }
SBSolarizedDarkTheme >> toolColor [

	^ Color fromString: 'fdf6e3'
]
