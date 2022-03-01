"
A SBJsComponentReplacement is a SBInlineBlockReplace for React Components that have a annotation for examples directly defined before their render method. The component needs to be a class and inherit from React.Component. Functional components are currently not supported. 
The annotation prior to the render method must be an assignment to the class variable ""examples"" in form of an array. This assignment will be replaced by this class.
Each entry in this array will be as one example in an independent MMBrowserMorph each. The MMBrowserMorph is directly below the example entry, which can be modified at will. But it should stay a valid JsObject in order for the example to work. The examples annotation must look like this: 
`examples = [{componentProps:{<props passed to the rendered component>}}, <maybe more entries>]`.
As the component is rendered inside a div in the example generated html page, it is possible to modify the div wrapping this component at free will. Just add property 'parentProps: {<options,,.>}' to the example object and the <options...> will be passed to that wrapping div.
Additionally, it is possible to have share properties between examples using a `sharedExampleProps = {<properties...>}` like annotation above the 'examples' annotation. The properties defined within the 'sharedExampleProps' can be accessed in the examples like it would be done with normal JS syntax.


Class Variables
	GeneratedHTMLFileDir		<String>
			
GeneratedHTMLFileDir
	- The directory where all generated files for the previews of examples should be saved at.
	

Interesting points where to start:
 - matchComponentExamples:do: This method tries to match for the examples annotation mentioned above in React.Component classes. If replaces each entry in the examples array with an example with a MMBrowserMorph. The examples are created in examplesFor: using newExample:withCaptures:filePath where the captures are a dict that contain the captures of the tree sitter query used to match the replacement.
- addNewEmptyExample is called once the addExample action is called on the render method SBInlineBlock to add a new example.

Dependency: A installed instance of the MagicMouse project in dev mode.
For better performance turn of the debugging flag in the settings.
"
Class {
	#name : #SBJsComponentReplacement,
	#superclass : #SBInlineBlockReplace,
	#classVars : [
		'GeneratedHTMLFileDir'
	],
	#category : #'Sandblocks-JavascriptReact'
}

{ #category : #'generate-html' }
SBJsComponentReplacement class >> exampleHTMLTemplateForExample: aJsObject withCaptures: aDictWithBlockCaptures [

	| usedComponentReplacements usedReactComponentsSourceStrings aJsObjectString |
	usedComponentReplacements := (aDictWithBlockCaptures at: 'class') collectComponentUsageReplacements asOrderedCollection.
	usedReactComponentsSourceStrings := usedComponentReplacements
		ifEmpty: ['']
		ifNotEmpty: [(usedComponentReplacements collect: [:aSBJsComponentUsageReplacement | aSBJsComponentUsageReplacement componentWrapper sourceString]) joinSeparatedBy: ' '].
	aJsObjectString := aDictWithBlockCaptures
		at: 'shared_example_props'
		ifPresent: [:anotherJsObject | anotherJsObject sourceString]
		ifAbsent: ['sharedExampleProps = {}'].
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
		<div {...parentProps}>
            	<', (aDictWithBlockCaptures at: 'class_name') contents, ' {...componentProps} />
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

{ #category : #accessing }
SBJsComponentReplacement class >> generatedHTMLFileDir [
	<preference: 'Html File Temp Folder' category: 'Sandblocks-JavascriptReact' description: 'Set the directory for the generated html files for magic mouse.' type: #String>

	^ GeneratedHTMLFileDir ifNil: ['~/Desktop']
]

{ #category : #accessing }
SBJsComponentReplacement class >> generatedHTMLFileDir: aString [

	GeneratedHTMLFileDir := aString
]

{ #category : #'inline-replacement' }
SBJsComponentReplacement class >> matchComponentExamples: aDictWithBlockCaptures do: aBlock [
	<lang: #javascript match: '(class_declaration
    name: (identifier) @class_name
	(class_heritage
		(member_expression
			object: (identifier) ="React"
			property: (identifier) ="Component"
		)
	)
    body: (class_body
	(field_definition
        	(property_identifier) ="sharedExampleProps"
	      (object)
        )? @shared_example_props
    	(field_definition
        	(property_identifier) ="examples"
	      (array) @example_array
        ) @example_array_declaration
	(method_definition
        	(property_identifier) ="render"
  	) @render_method
    )
) @class'>

	^ aBlock
		value: (aDictWithBlockCaptures at: 'example_array_declaration')
		value: (self new examplesFor: aDictWithBlockCaptures)
]

{ #category : #'inline-replacement' }
SBJsComponentReplacement class >> replacementQuery [

	| query |
	query := (self class >> #matchComponentExamples:do:) pragmas first arguments second copy.
	self flag: #TOOD.
	"Look where it is nessecarry to make the examples optional"
	^ query
	"at: (query findString: ' @example_array_declaration' startingAt: 0 caseSensitive: true) put: $?;
		yourself"
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
		newExample: defaultExampleObject
		withCaptures: self wrappedOwningClass allCaptures
		filePath: filePath.
	self submorphs second addMorphBack: newExample
]

{ #category : #accessing }
SBJsComponentReplacement >> allExamples [

	^ self submorphs second submorphs collect: [:submorph | submorph firstSubmorph]
]

{ #category : #saving }
SBJsComponentReplacement >> artefactSaved: anArtefact [

	anArtefact = self containingArtefact ifTrue: [self updateAllExamples]
]

{ #category : #accessing }
SBJsComponentReplacement >> drawnColor [

	^ Color veryDarkGray
]

{ #category : #replacing }
SBJsComponentReplacement >> examplesFor: aDictWithBlockCaptures [

	(aDictWithBlockCaptures at: 'example_array') access children withIndexDo: [:example :index | | filePath |
		filePath := self
			filePathForComponentName: (aDictWithBlockCaptures at: 'class_name') contents
			andIndex: index.
		self examplesRow addMorphBack: (self newExample: example withCaptures: aDictWithBlockCaptures filePath: filePath)]
]

{ #category : #accessing }
SBJsComponentReplacement >> examplesRow [

	^ self submorphs second
]

{ #category : #replacing }
SBJsComponentReplacement >> filePathForComponentName: aComponentNameString andIndex: index [

	^ self class generatedHTMLFileDir, 'Component_', aComponentNameString, '_', index asString, '.html'
]

{ #category : #replacing }
SBJsComponentReplacement >> filePathForIndex: index [

	^ self filePathForComponentName: self wrappedOwningClass componentName andIndex: index
]

{ #category : #accessing }
SBJsComponentReplacement >> initialize [

	super initialize.
	self
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

{ #category : #replacing }
SBJsComponentReplacement >> newExample: aJsObject withCaptures: aDictWithBlockCaptures filePath: aString [

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
				componentUsageReplacement := SBJsComponentUsageReplacement
					for: wrappedOwningClass
					withExample: aJsObject.
				SBJsReactComponentRegistry defaultRegistry
					addComponent: componentUsageReplacement
					withName: wrappedOwningClass componentName
					inCategory: category].
			self sandblockEditor rebuildPalette]]
]

{ #category : #replacing }
SBJsComponentReplacement >> updateAllExamples [

	| captures |
	captures := self wrappedOwningClass allCaptures.
	self submorphs second submorphs withIndexDo: [:exampleTuple :index | | browser jsObject filePath |
		browser := exampleTuple submorphs second firstSubmorph.
		jsObject := exampleTuple firstSubmorph.
		filePath := self filePathForComponentName: (captures at: 'class_name') contents andIndex: index.
		self class generateHtmlFileForExample: jsObject withCaptures: captures atFilePath: filePath.
		browser doRefresh]
]

{ #category : #saving }
SBJsComponentReplacement >> veryDeepCopyWith: deepCopier [

	| new |
	"Avoid having copies of browsers. Therefore we exclude the whole replacement and simply return a copy an equivalent annotation.
	If only the browser would be omitted, then the replacement would still try to refresh its non exsistent examples when asked for its sourceString.
	Therfore the best solution is to simply give a copy of the examples array."
	new := String streamContents: [:stream |
		stream nextPutAll: 'class {'.
		self writeSourceOn: stream.
		stream nextPutAll: '}'].
	^ (SBJavascript parseElement: new) access body member
]

{ #category : #accessing }
SBJsComponentReplacement >> wrappedOwningClass [

	^ SBJsReactComponentWrapper componentNode: self owningClass
]

{ #category : #saving }
SBJsComponentReplacement >> writeSourceOn: aStream [

	aStream
		nextPutAll: 'examples = [';
		nextPutAll: ((self allExamples collect: [:jsObject | jsObject sourceString]) joinSeparatedBy: ',');
		nextPutAll: ']'
]
