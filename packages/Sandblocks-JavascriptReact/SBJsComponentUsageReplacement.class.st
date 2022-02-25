"
A SBJsComponentUsageReplacement is a SBInlineBlockReplace that replaces the usage of a React Component via JSX.
It has a preview of the component's examples taken by the SBJsComponentScreenshotTaker and offers to adjust its props. The props are prefilled with the props of the first example the component has. Its usage is to be added to the TODOPalette and dragged from there into the React Code.


"
Class {
	#name : #SBJsComponentUsageReplacement,
	#superclass : #SBInlineBlockReplace,
	#instVars : [
		'referencedComponentClassSourceString',
		'usedComponents'
	],
	#category : #'Sandblocks-JavascriptReact'
}

{ #category : #'inline-replacement' }
SBJsComponentUsageReplacement class >> inlineComponentUsageReplacementFor: aReactComponentString forExample: aJsObject withName: reactClassName withUsedComponents: aCollection withSharedProps: sharedOptions [

	^ self new
		example: aJsObject
		forAComponent: reactClassName
		withComponentNode: aReactComponentString
		withUsedComponents: aCollection
		withSharedProps: sharedOptions
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
		withComponentSource: replacementComponent referencedComponentClassSourceString
		withExampleImage: replacementComponent previewImageCopy)
]

{ #category : #'inline-replacement' }
SBJsComponentUsageReplacement class >> queryForFirstValidExample [
	"Got no better solutution than to keep an extra copy of the query as it cannot be accessed from the pragma that simply."

	^ '(class_declaration
    name: (identifier) @class_name
    body: (class_body
	(field_definition
        	(property_identifier) ="sharedExampleProps"
	      (object)
        )? @shared_example_props
    	(field_definition
        	(property_identifier)="examples"
	      (array
			(object
				(pair
					(property_identifier)="componentProps"
					(object)
				) @first_valid_example
			)
		) @options
        ) @example_array
	(method_definition
        	(property_identifier)="render"
  	) @render_method
    )
) @class'
]

{ #category : #comparing }
SBJsComponentUsageReplacement >> = aComponentUsageReplacement [

	self componentName ifNil: [^ super = aComponentUsageReplacement].
	^ aComponentUsageReplacement class = self class and: [aComponentUsageReplacement componentName = self componentName]
]

{ #category : #collecting }
SBJsComponentUsageReplacement >> collectComponentUsageReplacements [

	| componentUsageReplacements |
	self flag: #TODO "refactor me".
	componentUsageReplacements := super collectComponentUsageReplacements.
	(componentUsageReplacements includes: self) ifFalse: [componentUsageReplacements add: self].
	self usedComponents do: [:component| (componentUsageReplacements includes: component) ifFalse:[componentUsageReplacements add: component]] .
	^ componentUsageReplacements
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

{ #category : #replacing }
SBJsComponentUsageReplacement >> example: aJsObject forAComponent: reactClassNameString withComponentNode: aReactComponentString withUsedComponents: aCollection withSharedProps: sharedOptions [

	| keyValuePairs componentPreviewImage jsxString componentProps |
	"TODO get key value pairs"
	componentProps := self componentPropsFromExampleObject: aJsObject.
	keyValuePairs := self keyValuesOfExampleObject: componentProps.
	self referencedComponentClassSourceString: aReactComponentString.
	
	jsxString := '<', reactClassNameString.
	keyValuePairs do: [:association | jsxString := jsxString, ' ', association key, '={', association value sourceString, '}'].
	jsxString := jsxString, ' ', '/>'.
	
	componentPreviewImage := SBJsComponentScreenshotTaker
		takeScreenshotOf: aReactComponentString
		withName: reactClassNameString
		withExample: aJsObject
		withUsedComponents: aCollection
		withSharedProps: sharedOptions
		withExtent: 1000 @ 1000.
	self flag: #TODO."Refactor this: Keep reference to original class and get the used replacents from there on demand"
	self usedComponents: aCollection.
	
	componentPreviewImage := self shrinkPreviewImage: componentPreviewImage.
	^ self
		factory: SBJavascript instance;
		removeAllMorphs;
		addMorphBack: (SBColumn new
			addMorphBack: (ImageMorph new image: componentPreviewImage);
			addMorphBack: (SBJavascript parse: jsxString) access children first element;
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

{ #category : #saving }
SBJsComponentUsageReplacement >> initialize [

	super initialize.
	self referencedComponentClassSourceString: '';
	usedComponents: OrderedCollection new.
]

{ #category : #'example-extracting' }
SBJsComponentUsageReplacement >> keyValuesOfExampleObject: aJsObject [

	^ (aJsObject access children reject: [:objectEntry | objectEntry type ~= 'pair']) collect: [:keyValuePair | keyValuePair key contents -> keyValuePair value]
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
		ifFalse: [aForm width > 200 ifTrue: [^ aForm scaledToWidth: 200]].
	^ aForm
]

{ #category : #accessing }
SBJsComponentUsageReplacement >> type [

	^ 'jsx_element'
]

{ #category : #accessing }
SBJsComponentUsageReplacement >> usedComponents [
	^ usedComponents
]

{ #category : #accessing }
SBJsComponentUsageReplacement >> usedComponents: aCollection [
	usedComponents := aCollection
]

{ #category : #saving }
SBJsComponentUsageReplacement >> writeSourceOn: aStream indent: aNumber [

	self firstSubmorph submorphs second
		writeSourceOn: aStream
		indent: aNumber
]
