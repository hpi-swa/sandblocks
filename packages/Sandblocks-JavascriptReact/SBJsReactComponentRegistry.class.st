Class {
	#name : #SBJsReactComponentRegistry,
	#superclass : #Object,
	#instVars : [
		'componentRegistry'
	],
	#classVars : [
		'DefaultRegistry'
	],
	#category : #'Sandblocks-JavascriptReact'
}

{ #category : #accessing }
SBJsReactComponentRegistry class >> defaultRegistry [

	^ DefaultRegistry ifNil: [self halt. DefaultRegistry := self new]
]

{ #category : #accessing }
SBJsReactComponentRegistry >> addComponent: aSbJsComponentUsageReplacement withName: anotherString [

	self componentRegistry at: anotherString put: [aSbJsComponentUsageReplacement]
]

{ #category : #accessing }
SBJsReactComponentRegistry >> componentRegistry [

	^ componentRegistry
]

{ #category : #accessing }
SBJsReactComponentRegistry >> componentRegistryDo: aBlock [

	self componentRegistry keysAndValuesDo: [:componentName :componentParsingBlock | aBlock value: componentName value: componentParsingBlock value]
]

{ #category : #accessing }
SBJsReactComponentRegistry >> initialize [

	super initialize.
	componentRegistry := Dictionary new
]
