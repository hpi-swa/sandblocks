"
An SBJsComponentUsageReplacement is a SBInlineBlockReplace that replaces the usage of a React Component as a JSX element directly within the code.
It can be created by creating a preview example for a component using the SBJsComponentReplacement and using its ""add to palette"" functionality. This will automatically create an instance of this class that references the example's component together with the props set for this example. During instantiation, a screenshot of the example is created using the SBJsComponentScreenshotTaker. The new instance is then automatically saved to the SBJsReactComponentRegistry's defaultRegistry.

The class tries to match every jsx element in javascript code and compares the element's component's name with the currently existing SBJsReactComponentRegistry defaultRegistry. If it finds an entry with a matching name, it takes a copy of the registered component's screenshot and with this creates an instance of this class to replace the jsx element. The replaced version still keeps the editable jsx code but also shows the screenshot above the code. This should make it easier to understand what the component visually represents.


Instance Variables
	componentWrapper		<SBJsReactComponentWrapper>

componentRegistry
	- An SBJsReactComponentWrapper referencing the AST nodes of the component used by this jsx element replacement. The wrapper is used to access certain parts of the referenced component on demand. E.g. get the whole source code of the referenced component in case the component where this replacement is in needs to generate an html example file for an example in an SBJsComponentReplacement.

Interesting points where to start:
- The class methode for:withExample: is used to take the screenshot of a given component using the component's SBJsReactComponentWrapper and an example of it. After taking the screenshot the new instance of this class is returned
- The class method matchComponentExamples:do: scans the javascript code for possible jsx element replacement using this class. This method covers the second paragraph described above.
"
Class {
	#name : #SBJsComponentUsageReplacement,
	#superclass : #SBInlineBlockReplace,
	#instVars : [
		'componentWrapper'
	],
	#category : #'Sandblocks-JavascriptReact'
}

{ #category : #'inline-replacement' }
SBJsComponentUsageReplacement class >> for: aSBJsReactComponentWrapper withExample: aJsObject [

	^ self new example: aJsObject componentWrapper: aSBJsReactComponentWrapper
]

{ #category : #'inline-replacement' }
SBJsComponentUsageReplacement class >> matchComponentExamples: aDictionary do: aBlock [
	<lang: #javascript match: '(jsx_self_closing_element) @element'>

	| element replacementComponent elementName blockToReplace |
	element := aDictionary at: 'element'.
	elementName := element access children first contents.
	replacementComponent := SBJsReactComponentRegistry defaultRegistry componentReplacementForComponentName: elementName.
	replacementComponent ifNil: [^ nil].
	blockToReplace := element owner owner class = self
		ifTrue: [element owner owner]
		ifFalse: [element].
	"First argument: What will be replaced, second argument: With what it will be replaced."
	^ aBlock value: blockToReplace value: (self new
		replacementFor: element
		withComponentWrapper: replacementComponent componentWrapper
		withExampleImage: replacementComponent previewImageCopy)
]

{ #category : #comparing }
SBJsComponentUsageReplacement >> = aComponentUsageReplacement [

	self componentName ifNil: [^ super = aComponentUsageReplacement].
	^ aComponentUsageReplacement class = self class and: [aComponentUsageReplacement componentName = self componentName]
]

{ #category : #collecting }
SBJsComponentUsageReplacement >> collectComponentUsageReplacements [

	| aSet |
	aSet := super collectComponentUsageReplacements.
	aSet
		add: self;
		addAll: self usedComponents.
	^ aSet
]

{ #category : #accessing }
SBJsComponentUsageReplacement >> componentName [

	| identifier |
	self access children size <= 0 ifTrue: [^ nil].
	identifier := self access children first.
	
	^ identifier children size > 0
		ifTrue: [identifier children first contents]
		ifFalse: [identifier contents]
]

{ #category : #'example-extracting' }
SBJsComponentUsageReplacement >> componentPropsFromExampleObject: aJsObject [

	^ aJsObject access children
		detect: [:objectEntry | objectEntry type = 'pair' and: [objectEntry key contents = 'componentProps']]
		ifFound: [:objectEntry | objectEntry access value]
]

{ #category : #accessing }
SBJsComponentUsageReplacement >> componentWrapper [

	^ componentWrapper
]

{ #category : #accessing }
SBJsComponentUsageReplacement >> componentWrapper: aSBJsReactComponentWrapper [

	componentWrapper := aSBJsReactComponentWrapper
]

{ #category : #replacing }
SBJsComponentUsageReplacement >> example: aJsObject componentWrapper: aSBJsReactComponentWrapper [

	| keyValuePairs componentPreviewImage jsxString componentProps |
	componentProps := self componentPropsFromExampleObject: aJsObject.
	keyValuePairs := self keyValuesOfExampleObject: componentProps.
	self componentWrapper: aSBJsReactComponentWrapper.
	
	jsxString := self
		jsxStringForProps: keyValuePairs
		withComponentName: aSBJsReactComponentWrapper componentName.
	
	componentPreviewImage := SBJsComponentScreenshotTaker
		takeScreenshotOf: aSBJsReactComponentWrapper
		withExample: aJsObject
		withExtent: 1000 @ 1000.
	componentPreviewImage := self shrinkPreviewImage: componentPreviewImage.
	
	^ self
		removeAllMorphs;
		addMorphBack: (SBColumn new
			addMorphBack: componentPreviewImage asMorph;
			addMorphBack: (SBJavascript parseElement: jsxString);
			changeTableLayout;
			hResizing: #shrinkWrap;
			vResizing: #shrinkWrap);
		changeTableLayout;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		yourself
]

{ #category : #saving }
SBJsComponentUsageReplacement >> initialize [

	super initialize.
	self factory: SBJavascript instance
]

{ #category : #'example-extracting' }
SBJsComponentUsageReplacement >> jsxStringForProps: aCollectionOfKeyValuePairs withComponentName: aString [

	^ String streamContents: [:stream |
		stream
			nextPutAll: '<';
			nextPutAll: aString.
		aCollectionOfKeyValuePairs do: [:association |
			stream
				space;
				nextPutAll: association key;
				nextPutAll: '={';
				nextPutAll: association value sourceString;
				nextPutAll: '}'].
		stream
			space;
			nextPutAll: '/>']
]

{ #category : #'example-extracting' }
SBJsComponentUsageReplacement >> keyValuesOfExampleObject: aJsObject [

	^ (aJsObject access children reject: [:objectEntry | objectEntry type ~= 'pair']) collect: [:keyValuePair | keyValuePair key contents -> keyValuePair value]
]

{ #category : #accessing }
SBJsComponentUsageReplacement >> previewImageCopy [

	^ self firstSubmorph firstSubmorph image copy
]

{ #category : #replacing }
SBJsComponentUsageReplacement >> replacementFor: aJsxSelfClosingElement withComponentWrapper: aSBJsReactComponentWrapper withExampleImage: aForm [

	self componentWrapper: aSBJsReactComponentWrapper.
	
	^ self
		factory: SBJavascript instance;
		removeAllMorphs;
		addMorphBack: (SBColumn new
			addMorphBack: aForm asMorph;
			addMorphBack: aJsxSelfClosingElement buildCopy;
			changeTableLayout;
			hResizing: #shrinkWrap;
			vResizing: #shrinkWrap);
		changeTableLayout;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		yourself
]

{ #category : #replacing }
SBJsComponentUsageReplacement >> shrinkPreviewImage: aForm [

	aForm height > (aForm width * 2)
		ifTrue: [aForm height > 100 ifTrue: [^ aForm scaledToHeight: 100]]
		ifFalse: [aForm width > 200 ifTrue: [^ aForm scaledToWidth: 200]].
	^ aForm
]

{ #category : #accessing }
SBJsComponentUsageReplacement >> type [

	^ 'jsx_element'
]

{ #category : #accessing }
SBJsComponentUsageReplacement >> usedComponents [

	^ self componentWrapper reactComponent collectComponentUsageReplacements
]

{ #category : #saving }
SBJsComponentUsageReplacement >> writeSourceOn: aStream indent: aNumber [

	self firstSubmorph submorphs second
		writeSourceOn: aStream
		indent: aNumber
]
