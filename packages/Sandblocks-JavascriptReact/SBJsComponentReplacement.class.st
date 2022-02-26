"
A SBJsComponentReplacement is a SBInlineBlockReplace for React Components that have a annotation for examples directly defined before their render method. The component needs to be a class and inherit from React.Component. Functional components are currently not supported. 
The annotation prior to the render method must be an assignment to the class variable ""examples"" in form of an array. This assignment will be replaced by this class.
Each entry in this array will be as one example in an independent MMBrowserMorph each. The MMBrowserMorph is directly below the example entry, which can be modified at will. But it should stay a valid JsObject in order for the example to work. The examples annotation must look like this: 
`examples = [{componentProps:{<props passed to the rendered component>}}, <maybe more entries>]`.
As the component is rendered inside a div in the example generated html page, it is possible to modify the div wrapping this component at free will. Just add property 'parentProps: {<options,,.>}' to the example object and the <options...> will be passed to that wrapping div.
Additionally, it is possible to have share properties between examples using a `sharedExampleProps = {<properties...>}` like annotation above the 'examples' annotation. The properties defined within the 'sharedExampleProps' can be accessed in the examples like it would be done with normal JS syntax.

Instance Variables
	skipHtmlFileGeneration:		<Boolean>

skipHtmlFileGeneration
	- This boolean signals whether to generate a html file for the component when saving changes / writeSourceOn: is called. This behaviour helps to automatically update the displayed examples in the MMBrowserMorph. As the generation of the html file needs the source string of the whole class, the generation needs to call writeSourceOn: itself. To evade endless recursion, skipHtmlFileGeneration is needed. The instance variable is set to true when the html file should be generated to aviod an endless recursion of creating html file. After the generation, it is set to false again. For more details see the writeSourceOn: method on the instance side.
If you want to get the sourceString of the component this instance is in without triggering a refresh of all examples, use the whileNotRefreshingExamples method.

Dependency: A installed instance of the MagicMouse project in dev mode.
For better performance turn of the debugging flag in the settings.
"
Class {
	#name : #SBJsComponentReplacement,
	#superclass : #SBInlineBlockReplace,
	#instVars : [
		'skipHtmlFileGeneration'
	],
	#category : #'Sandblocks-JavascriptReact'
}

{ #category : #'generate-html' }
SBJsComponentReplacement class >> exampleHTMLTemplateForExample: aJsObject withCaptures: aDictWithBlockCaptures [

	| usedComponentReplacements usedReactComponentsSourceStrings aJsObjectString |
	usedComponentReplacements := aDictWithBlockCaptures at: 'class'.
	usedReactComponentsSourceStrings := usedComponentReplacements
		ifEmpty: ['']
		ifNotEmpty: [(usedComponentReplacements collect: [:aSBJsComponentUsageReplacement | aSBJsComponentUsageReplacement referencedComponentClassSourceString]) joinSeparatedBy: ' '].
	aJsObjectString := (aDictWithBlockCaptures at: 'shared_example_props')
		ifNil: ['sharedExampleProps = {}']
		ifNotNil: [:anotherJsObject | anotherJsObject sourceString].
	^ '<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta name="theme-color" content="#000000" />

    <meta
      name="description"
      content="component testing example page"
    />
   <script src="https://unpkg.com/react@17.0.2/umd/react.production.min.js"></script>
    <script src="https://unpkg.com/react-dom@17/umd/react-dom.production.min.js"></script>
    <script src="https://unpkg.com/babel-standalone@6/babel.min.js"></script>
<link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css"
    />
<style>
 	/* Here is the place to add static CSS.*/
	body {
        margin: 0;
        font-family: Arial, Helvetica, sans-serif;
      }
	</style>
    <title>Example</title>
  </head>
  <body>
    <noscript>You need to enable JavaScript to run this app.</noscript>
    <div id="root">failed loading component ...</div>
    <script type="text/babel">
', usedReactComponentsSourceStrings, (aDictWithBlockCaptures at: 'class') sourceString, '
	const ', aJsObjectString, ';
	const { componentProps, parentProps } = ', aJsObject sourceString, ';
      ReactDOM.render(
		<div key={`container${index}`} {...parentProps}>
            	<', (aDictWithBlockCaptures at: 'class_name') sourceString, ' {...componentProps} />
  	       </div>, 
		document.getElementById("root"));
    </script>
  </body>
</html>'
]

{ #category : #'generate-html' }
SBJsComponentReplacement class >> filePathToURL: aString [

	^ 'file://', aString
]

{ #category : #'generate-html' }
SBJsComponentReplacement class >> generateHtmlFileForExample: aJsObject withCaptures: aDictWithBlockCaptures atFilePath: aString [

	| htmlString |
	htmlString := self exampleHTMLTemplateForExample: aJsObject withCaptures: aDictWithBlockCaptures.
	FileStream forceNewFileNamed: aString do: [:stream | stream nextPutAll: htmlString]
]

{ #category : #'inline-replacement' }
SBJsComponentReplacement class >> matchComponentExamples: aDictWithBlockCaptures do: aBlock [
	"First argument: What will be replaced, second argument: With what it will be replaced."
	<lang: #javascript match: '(class_declaration
    name: (identifier) @class_name
	(class_heritage
		(member_expression
			object: (identifier) ="React"
			property: (idenfifier) ="Component"
		)
	)
    body: (class_body
	(field_definition
        	(property_identifier) ="sharedExampleProps"
	      (object)
        )? @shared_example_props
    	(field_definition
        	(property_identifier) ="examples"
	      (array) @options
        ) @example_array
	(method_definition
        	(property_identifier) ="render"
  	) @render_method
    )
) @class'>

	^ aBlock
		value: (aDictWithBlockCaptures at: 'example_array')
		value: (self new examplesFor: aDictWithBlockCaptures)
]

{ #category : #'inline-replacement' }
SBJsComponentReplacement class >> replacementQuery [
	"Got no better solutution than to keep an extra copy of the query as it cannot be accessed from the pragma that simply."

	^ (self class >> #matchComponentExamples:do:) pragmas first arguments second
]

{ #category : #'generate-html' }
SBJsComponentReplacement class >> testHTMLFileDir [

	^ '/Users/michael/Desktop/MMFiles/'
]

{ #category : #replacing }
SBJsComponentReplacement >> addNewEmptyExample [

	| newExample defaultExampleObject exampleCount filePath |
	exampleCount := self allExamples size.
	defaultExampleObject := SBJavascript parseElement: '{componentProps:{}}'.
	filePath := self filePathForIndex: exampleCount + 1.
	newExample := self
		newExampleExample: defaultExampleObject
		withCaptures: self wrappedOwningClass allCaptures
		filePath: filePath.
	self submorphs second addMorphBack: newExample
]

{ #category : #accessing }
SBJsComponentReplacement >> allExamples [

	^ self submorphs second submorphs collect: [:submorph | submorph firstSubmorph]
]

{ #category : #accessing }
SBJsComponentReplacement >> drawnColor [

	^ Color veryDarkGray
]

{ #category : #replacing }
SBJsComponentReplacement >> examplesFor: aDictWithBlockCaptures [

	(aDictWithBlockCaptures at: 'example_array') access children withIndexDo: [:example :index | | filePath |
		filePath := self filePathForComponentName: (aDictWithBlockCaptures at: 'class_name') andIndex: index.
		self examplesRow addMorphBack: (self newExampleExample: example withCaptures: aDictWithBlockCaptures filePath: filePath)]
]

{ #category : #accessing }
SBJsComponentReplacement >> examplesRow [

	^ self submorphs second
]

{ #category : #replacing }
SBJsComponentReplacement >> filePathForComponentName: aComponentNameString andIndex: index [

	^ self class testHTMLFileDir, 'Component_', aComponentNameString, '_', index asString, '.html'
]

{ #category : #replacing }
SBJsComponentReplacement >> filePathForIndex: index [

	^ self filePathForComponentName: self wrappedOwningClass componentName andIndex: index
]

{ #category : #accessing }
SBJsComponentReplacement >> initialize [

	super initialize.
	self
		skipHtmlFileGeneration: false;
		listDirection: #topToBottom;
		addMorphBack: (SBRow new
			layoutInset: 4;
			addMorphBack: (SBStringMorph new
				contents: 'examples';
				bold));
		addMorphBack: (SBRow new
			cellGap: 8;
			layoutInset: 4;
			yourself)
]

{ #category : #accessing }
SBJsComponentReplacement >> isSBJsComponentReplacement [

	^ true
]

{ #category : #replacing }
SBJsComponentReplacement >> newExampleExample: aJsObject withCaptures: aDictWithBlockCaptures filePath: aString [

	| aJSArrayWithName exampleOptionsCopy |
	aJSArrayWithName := 'examples = [', aJsObject sourceString, ']'.
	self class
		generateHtmlFileForExample: aJsObject
		withCaptures: aDictWithBlockCaptures
		atFilePath: aString.
	exampleOptionsCopy := aJsObject buildCopy.
	
	^ SBColumn new
		addMorphBack: exampleOptionsCopy;
		addMorphBack: (SBJsMMBrowserWrapper new
			addMorphBack: (MMBrowserMorph reactOpenOn: (self class filePathToURL: aString));
			layoutInset: 8;
			changeTableLayout;
			hResizing: #shrinkWrap;
			vResizing: #shrinkWrap;
			yourself);
		addMorphBack: (self savePaletteButtonForExample: exampleOptionsCopy);
		borderWidth: 2;
		changeTableLayout;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		yourself
]

{ #category : #replacing }
SBJsComponentReplacement >> savePaletteButtonForExample: aJsObject [

	^ SBButton new icon: SBIcon iconSave label: 'Save to Palette' do: [ | category componentUsageReplacement wrappedOwningClass |
		wrappedOwningClass := self wrappedOwningClass.
		category := UIManager default
			chooseFromOrAddTo: SBJsReactComponentRegistry defaultRegistry allCategories
			lines: nil
			title: 'Choose Category'.
		category ifNotNil: [
			Cursor wait showWhile: [
				self skipHtmlFileGeneration: true.
				self whileNotRefreshingExamples: [
					componentUsageReplacement := SBJsComponentUsageReplacement
						for: wrappedOwningClass
						withExample: aJsObject.
					SBJsReactComponentRegistry defaultRegistry
						addComponent: componentUsageReplacement
						withName: wrappedOwningClass componentName
						inCategory: category].
				self sandblockEditor rebuildPalette]]]
]

{ #category : #accessing }
SBJsComponentReplacement >> skipHtmlFileGeneration [

	^ skipHtmlFileGeneration
]

{ #category : #accessing }
SBJsComponentReplacement >> skipHtmlFileGeneration: aBoolean [

	skipHtmlFileGeneration := aBoolean
]

{ #category : #replacing }
SBJsComponentReplacement >> updateAllExamples [

	| captures |
	captures := self wrappedOwningClass allCaptures.
	self submorphs second submorphs withIndexDo: [:exampleTuple :index | | browser jsObject filePath |
		browser := exampleTuple submorphs second firstSubmorph.
		jsObject := exampleTuple firstSubmorph.
		filePath := self filePathForComponentName: (captures at: 'class_name') andIndex: index.
		self class generateHtmlFileForExample: jsObject withCaptures: captures atFilePath: filePath.
		browser doRefresh]
]

{ #category : #saving }
SBJsComponentReplacement >> veryDeepCopyWith: deepCopier [

	| new examplesRow |
	"Assure that the browser morph is not included in the deepCopy; Does not seem to work :/ "
	self submorphs second.
	examplesRow := self submorphs second.
	self removeMorph: examplesRow.
	new := super veryDeepCopyWith: deepCopier.
	self addMorphBack: examplesRow.
	
	^ new
]

{ #category : #saving }
SBJsComponentReplacement >> whileNotRefreshingExamples: aBlock [

	[
		self skipHtmlFileGeneration: true.
		aBlock value] ensure: [self skipHtmlFileGeneration: false]
]

{ #category : #accessing }
SBJsComponentReplacement >> wrappedOwningClass [

	^ SBJsReactComponentWrapper reactComponent: self owningClass
]

{ #category : #saving }
SBJsComponentReplacement >> writeSourceOn: aStream [

	| optionsObject |
	optionsObject := 'examples = [', ((self allExamples collect: [:jsObject | jsObject sourceString]) joinSeparatedBy: ','), ']'.
	aStream nextPutAll: optionsObject.
	self skipHtmlFileGeneration ifFalse: [self whileNotRefreshingExamples: [self updateAllExamples]]
]
