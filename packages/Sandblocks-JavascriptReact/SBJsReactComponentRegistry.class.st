"
A SBJsReactComponentRegistry is object that saves SBJsComponentUsageReplacements associated with a name and a category much like a small database. 
There should only be single single running instance at a time to ensure that all access the same registry. The running instance is saved via the DefaultRegistry variable. 
On the instance side the SBJsComponentUsageReplacements are stored in the componentRegistry dictionary and can be accessed via convenience functions like componentRegistryDo:.

Instance Variables
	componentRegistry:		<Dictionary>

componentRegistry
	- A Dictionary storing the SBJsComponentUsageReplacements together with their names by category. The structure is a that of a nested Dictionary.


Class Variables
	DefaultRegistry:		<SBJsReactComponentRegistry>
			
DefaultRegistry
	- The default instance of the SBJsReactComponentRegistry that should be used all the time.
"
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

	^ DefaultRegistry ifNil: [DefaultRegistry := self new]
]

{ #category : #adding }
SBJsReactComponentRegistry >> addComponent: aSbJsComponentUsageReplacement withName: anotherString [

	self flag: #TODO.
	"Add argument to give a category"
	
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
