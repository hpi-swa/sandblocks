"
A SBJsComponentUsageReplacement is a SBInlineBlockReplace that replaces the usage of a React Component via JSX.
It has a preview of the component's examples taken by the SBJsComponentScreenshotTaker and offers to adjust its props. The props are prefilled with the props of the first example the component has. Its usage is to be added to the TODOPalette and dragged from there into the React Code.


"
Class {
	#name : #SBJsComponentUsageReplacement,
	#superclass : #SBInlineBlockReplace,
	#instVars : [
		'referencedComponentClassSourceString'
	],
	#category : #'Sandblocks-JavascriptReact'
}

{ #category : #'inline-replacement' }
SBJsComponentUsageReplacement class >> inlineComponentUsageReplacementFor: aReactComponentString [

	| reactComponentAST |
	reactComponentAST := SBJavascript parse: aReactComponentString.
	reactComponentAST allBlocksDo: [:block |
		SBTSQuery new execute: SBJsComponentReplacement replacementQuery against: block capturesDo: [:captures :success |
			success ifTrue: [ | reactClassName examples |
				reactClassName := (captures at: 'class_name') contents.
				examples := captures at: 'options'.
				^ self new
					examples: examples
					forAComponent: reactClassName
					withComponentNode: aReactComponentString]]].
	self signal: (Error signal: 'Could not find a valid examples array in the given component.')
]

{ #category : #'inline-replacement' }
SBJsComponentUsageReplacement class >> matchComponentExamples: aDictionary do: aBlock [
	<lang: #javascript match: '(jsx_self_closing_element) @element'>

	| element replacementComponent elementName |
	element := aDictionary at: 'element'.
	elementName := element access children first contents.
	replacementComponent := SBJsReactComponentRegistry defaultRegistry componentReplacementForComponentName: elementName.
	replacementComponent ifNil: [^ nil].
	"First argument: What will be replaced, second argument: With what it will be replaced."
	^ aBlock value: element value: (self new
		replacementFor: element
		withComponentSource: replacementComponent referencedComponentClassSourceString
		withExampleImage: replacementComponent previewImageCopy)
]

{ #category : #comparing }
SBJsComponentUsageReplacement >> = aComponentUsageReplacement [

	^ aComponentUsageReplacement class = self class and: [aComponentUsageReplacement componentName = self componentName]
]

{ #category : #collecting }
SBJsComponentUsageReplacement >> collectComponentUsageReplacements [

	| componentUsageReplacements |
	componentUsageReplacements := super collectComponentUsageReplacements.
	(componentUsageReplacements includes: self) ifFalse: [componentUsageReplacements add: self].
	^ componentUsageReplacements
]

{ #category : #accessing }
SBJsComponentUsageReplacement >> componentName [
	
	|identifier|
	identifier :=  self firstSubmorph submorphs second access children first.

	^ identifier children size > 0 ifTrue:[identifier children first contents] ifFalse: [identifier contents]
]

{ #category : #'example-extracting' }
SBJsComponentUsageReplacement >> componentPropsFromExampleObject: aJsObject [

	aJsObject children do: [:objectEntry | (objectEntry type = 'pair' and: [objectEntry key contents = 'componentProps']) ifTrue: [^ objectEntry value]].
	^ self error: (Error signal: 'Could not find ''componentProps'' in example object')
]

{ #category : #replacing }
SBJsComponentUsageReplacement >> examples: aJsArray forAComponent: reactClassNameString withComponentNode: aReactComponentString [

	| validExampleIndex examplePropsObject keyValuePairs componentPreviewImage jsxString |
	validExampleIndex := self indexOfFirstValidExampleEntry: aJsArray.
	examplePropsObject := self componentPropsFromExampleObject: (aJsArray access children at: validExampleIndex).
	keyValuePairs := self keyValuesOfExampleIObject: examplePropsObject.
	self referencedComponentClassSourceString: aReactComponentString.
	
	jsxString := '<', reactClassNameString.
	keyValuePairs do: [:association | jsxString := jsxString, ' ', association key, '={', association value sourceString,'}'].
	jsxString := jsxString, ' ', '/>'.
	
	componentPreviewImage := SBJsComponentScreenshotTaker
		takeScreenshotOf: aReactComponentString
		atExample: validExampleIndex
		withExtent: 1000 @ 1000.
	componentPreviewImage := self shrinkPreviewImage: componentPreviewImage.
	^ self
		factory: SBJavascript instance;
		removeAllMorphs;
		addMorphBack: (SBColumn new
			addMorphBack: (ImageMorph new image: componentPreviewImage);
			addMorphBack: (SBJavascript parse: jsxString);
			changeTableLayout;
			hResizing: #shrinkWrap;
			vResizing: #shrinkWrap);
		changeTableLayout;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		yourself
]

{ #category : #'example-extracting' }
SBJsComponentUsageReplacement >> indexOfFirstValidExampleEntry: aJsArray [

	aJsArray access children withIndexDo: [:arrayEntry :index | (arrayEntry type = 'object' and: [arrayEntry children anySatisfy: [:objectEntry | objectEntry type = 'pair' and: [objectEntry key contents = 'componentProps']]]) ifTrue: [^ index]].
	^ self error: (Error signal: 'Could not find an example with ''componentProps'' set')
]

{ #category : #'example-extracting' }
SBJsComponentUsageReplacement >> keyValuesOfExampleIObject: aJsObject [

	^ (aJsObject children reject: [:objectEntry | objectEntry type ~= 'pair']) collect: [:keyValuePair | keyValuePair key contents -> keyValuePair value]
]

{ #category : #accessing }
SBJsComponentUsageReplacement >> previewImageCopy [

	^ self firstSubmorph firstSubmorph image copy
]

{ #category : #accessing }
SBJsComponentUsageReplacement >> referencedComponentClassSourceString [

	^ referencedComponentClassSourceString
]

{ #category : #accessing }
SBJsComponentUsageReplacement >> referencedComponentClassSourceString: aString [

	referencedComponentClassSourceString := aString
]

{ #category : #replacing }
SBJsComponentUsageReplacement >> replacementFor: aJsxSelfClosingElement withComponentSource: aReactComponentString withExampleImage: aForm [

	self referencedComponentClassSourceString: aReactComponentString.
	
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
		ifFalse: [aForm width > (200) ifTrue: [^ aForm scaledToWidth: 200]].
	^ aForm
]

{ #category : #accessing }
SBJsComponentUsageReplacement >> type [

	^ 'jsx_expression'
]

{ #category : #saving }
SBJsComponentUsageReplacement >> writeSourceOn: aStream indent: aNumber [

	self firstSubmorph submorphs second writeSourceOn: aStream indent: aNumber
]
