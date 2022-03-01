"
An SBJsReactPalette is SBPalette for SBJsComponentUsageReplacements. It uses the default SBJsReactComponentRegistry to render its contents structured by the categories given by the registry.

Instance Variables
	- None
"
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
