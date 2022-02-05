"
A SBJsComponentUsageReplacement is a SBInlineBlockReplace that replaces the usage of a React Component via JSX.
It has a preview of the component's examples taken by the SBJsComponentScreenshotTaker and offers to adjust its props. The props are prefilled with the props of the first example the component has. Its usage is to be added to the TODOPalette and dragged from there into the React Code.


"
Class {
	#name : #SBJsComponentUsageReplacement,
	#superclass : #SBInlineBlockReplace,
	#category : #'Sandblocks-JavascriptReact'
}

{ #category : #'as yet unclassified' }
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
					withComponentNode: aReactComponentString.
				]]].
	self signal: (Error signal: 'Could not find a valid examples array in the given component.')
]

{ #category : #'example-extracting' }
SBJsComponentUsageReplacement >> componentPropsFromExampleObject: aJsObject [

	aJsObject children do: [:objectEntry | (objectEntry type = 'pair' and: [objectEntry key contents = 'componentProps']) ifTrue: [^ objectEntry value]].
	^ self error: (Error signal: 'Could not find ''componentProps'' in example object')
]

{ #category : #replacing }
SBJsComponentUsageReplacement >> examples: aJsArray forAComponent: reactClassNameString withComponentNode: aReactComponentString [

	| validExampleIndex examplePropsObject keyValuePairs componentPreviewImage jsxString|
	validExampleIndex := self indexOfFirstValidExampleEntry: aJsArray.
	examplePropsObject := self componentPropsFromExampleObject: (aJsArray access children at: validExampleIndex).
	keyValuePairs := self keyValuesOfExampleIObject: examplePropsObject.
	
	jsxString := '<', reactClassNameString.
	keyValuePairs do: [:association |
		jsxString := jsxString, ' ', association key, '=', association value sourceString].
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
			changeTableLayout;
			hResizing: #shrinkWrap;
			vResizing: #shrinkWrap;
			addMorphBack: (ImageMorph new image: componentPreviewImage);
			addMorphBack: (SBJavascript parse: jsxString));
		changeTableLayout;
			hResizing: #shrinkWrap;
			vResizing: #shrinkWrap; yourself
			
		
	
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

{ #category : #replacing }
SBJsComponentUsageReplacement >> shrinkPreviewImage: aForm [

	aForm height > aForm width 
		ifTrue: [aForm height > 100 ifTrue:[^ aForm scaledToHeight: 100]]
		ifFalse:[aForm width > 100 ifTrue: [^ aForm scaledToWidth: 100]].
	^ aForm.
]

{ #category : #accessing }
SBJsComponentUsageReplacement >> type [

	^ 'jsx_expression'
]

{ #category : #saving }
SBJsComponentUsageReplacement >> writeSourceOn: aStream indent: aNumber [

	self lastSubmorph writeSourceOn: aStream indent: aNumber
]
