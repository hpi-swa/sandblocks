Class {
	#name : #SBJsComponentUsageReplacement,
	#superclass : #SBInlineBlockReplace,
	#instVars : [
		'skipHtmlFileGeneration'
	],
	#category : #'Sandblocks-JavascriptReact'
}

{ #category : #'as yet unclassified' }
SBJsComponentUsageReplacement class >> inlineComponentUsageReplacementFor: aReactComponentString [

	| reactComponentAST |
	reactComponentAST := SBJavascript parse: aReactComponentString.
	reactComponentAST allBlocksDo: [:block |
		SBTSQuery new execute: SBJsComponentReplacement replacementQuery against: block capturesDo: [:captures :success |
			(success and: [SBJsComponentReplacement isMatchCorrect: captures]) ifTrue: [ | reactClassName examples |
				reactClassName := (captures at: 'class_name') contents.
				examples := captures at: 'options'.
				^ self new
					examples: examples
					forAComponent: reactClassName
					withComponentNode: aReactComponentString.
				
				]]].
	self signal: (Error signal: 'Could not find a valid examples array in the given component.')
]

{ #category : #'as yet unclassified' }
SBJsComponentUsageReplacement >> componentPropsFromExampleObject: aJsObject [
	
	aJsObject children do: [:objectEntry | (objectEntry type = 'pair' and: [objectEntry key contents = 'componentProps']) ifTrue: [^ objectEntry value]].
	^ self error: (Error signal: 'Could not find ''componentProps'' in example object')
]

{ #category : #'as yet unclassified' }
SBJsComponentUsageReplacement >> examples: aJsArray forAComponent: reactClassNameString withComponentNode: aReactComponentString [

	| validExampleIndex examplePropsObject row keyValuePairs |
	validExampleIndex := self indexOfFirstValidExampleEntry: aJsArray.
	examplePropsObject := self componentPropsFromExampleObject: (aJsArray access children at: validExampleIndex).
	keyValuePairs := self keyValuesOfExampleIObject: examplePropsObject.
	
	row := SBRow new
		cellGap: 7;
		addMorphBack: (SBStringMorph new contents: '<', reactClassNameString);
		yourself.
	keyValuePairs do: [:association |
		row
			addMorphBack: (SBStringMorph new contents: association key, '=');
			addMorphBack: association value].
	row addMorphBack: (SBStringMorph new contents: '/>').
	
	^ self
		factory: SBJavascript instance;
		removeAllMorphs;
		addMorphBack: row;
		yourself
]

{ #category : #'as yet unclassified' }
SBJsComponentUsageReplacement >> indexOfFirstValidExampleEntry: aJsArray [

	aJsArray access children withIndexDo: [:arrayEntry :index | (arrayEntry type = 'object' and: [arrayEntry children anySatisfy: [:objectEntry | objectEntry type = 'pair' and: [objectEntry key contents = 'componentProps']]]) ifTrue: [^ index]].
	^ self error: (Error signal: 'Could not find an example with ''componentProps'' set')
]

{ #category : #'as yet unclassified' }
SBJsComponentUsageReplacement >> keyValuesOfExampleIObject: aJsObject [

	^ (aJsObject children reject: [:objectEntry | objectEntry type ~= 'pair']) collect: [:keyValuePair | keyValuePair key contents -> keyValuePair value]
]
