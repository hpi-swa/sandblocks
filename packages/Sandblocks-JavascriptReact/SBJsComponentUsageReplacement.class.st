"
A SBJsComponentUsageReplacement is a SBInlineBlockReplace that replaces the usage of a React Component via JSX.
It has a preview of the component's examples taken by the SBJsComponentScreenshotTaker and offers to adjust its props. The props are prefilled with the props of the first example the component has. Its usage is to be added to the TODOPalette and dragged from there into the React Code.


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

	aJsObject access children do: [:objectEntry | (objectEntry type = 'pair' and: [objectEntry key contents = 'componentProps']) ifTrue: [^ objectEntry value]].
	^ self error: (Error signal: 'Could not find ''componentProps'' in example object')
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
	
	jsxString := '<', aSBJsReactComponentWrapper componentName.
	keyValuePairs do: [:association | jsxString := jsxString, ' ', association key, '={', association value sourceString, '}'].
	jsxString := jsxString, ' ', '/>'.
	
	componentPreviewImage := SBJsComponentScreenshotTaker
		takeScreenshotOf: aSBJsReactComponentWrapper
		withExample: aJsObject
		withExtent: 1000 @ 1000.
	componentPreviewImage := self shrinkPreviewImage: componentPreviewImage.
	
	^ self
		removeAllMorphs;
		addMorphBack: (SBColumn new
			addMorphBack: (ImageMorph new image: componentPreviewImage);
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
	self
		referencedComponentClassSourceString: '';
		usedComponents: OrderedCollection new;
		factory: SBJavascript instance
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
			addMorphBack: (ImageMorph new image: aForm);
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

	self componentWrapper reactComponent collectComponentUsageReplacements
]

{ #category : #saving }
SBJsComponentUsageReplacement >> writeSourceOn: aStream indent: aNumber [

	self firstSubmorph submorphs second
		writeSourceOn: aStream
		indent: aNumber
]
