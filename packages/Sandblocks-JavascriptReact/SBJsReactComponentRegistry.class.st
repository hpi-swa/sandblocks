"
An SBJsReactComponentRegistry is an object that saves SBJsComponentUsageReplacements associated with a name and a category much like a small key-value database. 
There should only be single running instance at a time to ensure that all access the same registry. The running instance is saved via the DefaultRegistry class variable. 
On the instance side, the SBJsComponentUsageReplacements are stored in the nested componentRegistry dictionary and can be accessed via convenience functions like componentRegistryDo:.
The registered components in the DefaultRegistry are automatically added to the SBJsReactPalette and are used for suggestions in JSX context. For the suggestions look into SBJavascript>>insertSuggestionsFor:.

The convenience functions are mainly unused and exist for programmers to interact with the SBJsComponentUsageReplacements instance. Thus they extend the SBJsReactPalette and the JSX suggestions on their own.

Instance Variables
	componentRegistry:		<Dictionary>

componentRegistry
	- A Dictionary storing the SBJsComponentUsageReplacements together with their names by category. The structure is that of a nested Dictionary.


Class Variables
	DefaultRegistry:		<SBJsReactComponentRegistry>
			
DefaultRegistry
	- The default instance of the SBJsReactComponentRegistry which should be used all the time.
	

Interesting points where to start:
- The class method resetDefaultRegistry replaces the old default registry with a new one and therefore effectivly clears the registry.
- The methode addComponent:withName:inCategory: is used by the SBJsComponentReplacement to add created SBJsComponentUsageReplacement to the registry.
- Additionally, the registry offeres convinience functions to access all entries, only specific categories and even methods to delete entries. The methods for deleting all start with remove and are in category ""removing"".
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

{ #category : #accessing }
SBJsReactComponentRegistry class >> resetDefaultRegistry [
	"Only use when necessary; when the registry should be flushed"

	^ DefaultRegistry := self new
]

{ #category : #adding }
SBJsReactComponentRegistry >> addComponent: aSBJsComponentUsageReplacement withName: aString [

	self addComponent: aSBJsComponentUsageReplacement withName: aString inCategory: 'default'
]

{ #category : #adding }
SBJsReactComponentRegistry >> addComponent: aSBJsComponentUsageReplacement withName: aString inCategory: anotherString [

	self componentRegistry
		at: anotherString
		ifPresent: [:entriesOfCategory | entriesOfCategory at: aString put: aSBJsComponentUsageReplacement]
		ifAbsentPut: [
			Dictionary new
				at: aString put: aSBJsComponentUsageReplacement;
				yourself]
]

{ #category : #accessing }
SBJsReactComponentRegistry >> allCategories [

	^ self componentRegistry keys
]

{ #category : #accessing }
SBJsReactComponentRegistry >> componentRegistry [

	^ componentRegistry
]

{ #category : #accessing }
SBJsReactComponentRegistry >> componentRegistryCategoriesDo: aBlock [

	self componentRegistry keysAndValuesDo: [:categoryName :componentReplacementsDict | aBlock value: categoryName value: componentReplacementsDict]
]

{ #category : #accessing }
SBJsReactComponentRegistry >> componentRegistryComponents [

	| allReplacementComponents |
	allReplacementComponents := OrderedCollection new.
	self componentRegistry keysAndValuesDo: [:categoryName :componentReplacementsDict | allReplacementComponents addAll: componentReplacementsDict associations].
	^ allReplacementComponents
]

{ #category : #accessing }
SBJsReactComponentRegistry >> componentReplacementForComponentName: aString [

	self componentRegistry do: [:catgoryEntries | catgoryEntries keysAndValuesDo: [:componentName :componentReplacement | componentName = aString ifTrue: [^ componentReplacement]]].
	^ nil
]

{ #category : #accessing }
SBJsReactComponentRegistry >> initialize [

	super initialize.
	componentRegistry := Dictionary new
]

{ #category : #removing }
SBJsReactComponentRegistry >> removeComponentByName: aString [

	self componentRegistryCategoriesDo: [:categoryName :entries | self removeComponentByName: aString inCategory: categoryName ifAbsent: []]
]

{ #category : #removing }
SBJsReactComponentRegistry >> removeComponentByName: aString inCategory: anotherString [

	self
		removeComponentByName: aString
		inCategory: anotherString
		ifAbsent: [self signal: 'Could not find ', aString, ' in category ', anotherString]
]

{ #category : #removing }
SBJsReactComponentRegistry >> removeComponentByName: aString inCategory: anotherString ifAbsent: aBlock [

	(self componentRegistry at: anotherString)
		removeKey: aString
		ifAbsent: aBlock
]
