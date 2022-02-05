Class {
	#name : #SBJsReactPalette,
	#superclass : #SBTSPalette,
	#category : #'Sandblocks-JavascriptReact'
}

{ #category : #'as yet unclassified' }
SBJsReactPalette class >> buildOn: aBuilder [

	aBuilder addHeader: 'React'.
	SBJsReactComponentRegistry defaultRegistry componentRegistryCategoriesDo: [:categoryName :entries |
		aBuilder addSectionHeader: categoryName.
		entries keysAndValuesDo: [:componentName :component | aBuilder addBlock: componentName as: component]]
]

{ #category : #'as yet unclassified' }
SBJsReactPalette class >> language [

	^ #javascript
]
