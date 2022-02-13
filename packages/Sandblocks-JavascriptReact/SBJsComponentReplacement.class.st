"
A SBJsComponentReplacement is a SBInlineBlockReplace for React Components that have a annotation for examples directly defined before their render method. The component needs to be a class, not a functional component. 
The annotation prior to the render method must be an assignment to the class variable ""examples"" in form of an array.
Each entry in this array will be rendered one below the other as an example in a MMBrowserMorph. The MMBrowserMorph is directly next to the examples array and above the render method. Thus this replacement replaces the assignment to the ""examples"" class variable. The annotation must look like this: 
`examples = [{componentProps:{<props passed to the rendered component>}}, <maybe more entries>]`.

Instance Variables
	skipHtmlFileGeneration:		<Boolean>

skipHtmlFileGeneration
	- This boolean signals whether to generate a html file for the component when saving changes / writeSourceOn: is called. This behaviour helps to automatically update the displayed examples in the MMBrowserMorph. As the generation of the html file needs the source string of the whole class, the generation needs to call writeSourceOn: itself. To evade endless recursion, skipHtmlFileGeneration is needed. The instance variable is set to true when the html file should be generated to aviod an endless recursion of creating html file. After the generation, it is set to false again. For more details see the writeSourceOn: method on the instance side.

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
SBJsComponentReplacement class >> exampleHTMLTemplateFor: aSourceCodeString forClass: aClassNameString withOptions: aArrayString withUsedReactComponents: aOrderedCollection withSharedProps: aJsObjectStringMaybe [

	| usedReactComponentsSourceStrings aJsObjectString |
	"self halt."
	usedReactComponentsSourceStrings := aOrderedCollection
		ifEmpty: ['']
		ifNotEmpty: [(aOrderedCollection collect: [:aSBJsComponentUsageReplacement | aSBJsComponentUsageReplacement referencedComponentClassSourceString]) joinSeparatedBy: ' '].
	aJsObjectString := aJsObjectStringMaybe
		ifNil: ['sharedExampleProps = {}']
		ifNotNil: [aJsObjectStringMaybe sourceString].
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
		body {
        margin: 0;
        font-family: Arial, Helvetica, sans-serif;
      }

      .topnav {
        background-color: #333;
        position: sticky;
        top: 0px;
        width: 100%;
        height: 48px;
      }

      .topnav > a,
      .topnav > span,
      .topnav > div {
        float: left;
        color: #f2f2f2;
        text-align: center;
        padding: 14px 16px;
        text-decoration: none;
        font-size: 17px;
      }

      .topnav > a:hover,
      .topnav > span:hover,
      .topnav > div:hover {
        background-color: #ddd;
        color: black;
      }

      .main-content {
        text-align: center;
        padding: 40px 100px;
      }

      .topnav a.active {
        background-color: #04aa6d;
        color: white;
      }

      table {
        font-family: arial, sans-serif;
        border-collapse: collapse;
        width: 100%;
      }

      td,
      th {
        border: 1px solid #dddddd;
        text-align: left;
        padding: 8px;
      }

      tr:nth-child(even) {
        background-color: #dddddd;
      }
      .search-container input[type="text"] {
        padding: 6px;
        margin-top: 8px;
        font-size: 17px;
        border-color: #ddd;
        border-style: double;
      }

      .search-container button {
        padding: 8px 10px;
        margin-top: 8px;
        margin-right: 16px;
        background: #ddd;
        font-size: 17px;
        border: none;
        cursor: pointer;
      }

      @keyframes spin {
        100% {
          transform: rotate(360deg);
        }
      }

      #snackbar {
        visibility: hidden;
        min-width: 250px;
        margin-left: -125px;
        background-color: #555;
        color: #fff;
        text-align: center;
        border-radius: 2px;
        padding: 16px;
        position: fixed;
        z-index: 1;
        left: 50%;
        bottom: 30px;
        font-size: 17px;
      }

      #snackbar.show {
        visibility: visible;
        -webkit-animation: fadein 0.5s, fadeout 0.5s 2.5s;
        animation: fadein 0.5s, fadeout 0.5s 2.5s;
      }

      @-webkit-keyframes fadein {
        from {
          bottom: 0;
          opacity: 0;
        }
        to {
          bottom: 30px;
          opacity: 1;
        }
      }

      @keyframes fadein {
        from {
          bottom: 0;
          opacity: 0;
        }
        to {
          bottom: 30px;
          opacity: 1;
        }
      }

      @-webkit-keyframes fadeout {
        from {
          bottom: 30px;
          opacity: 1;
        }
        to {
          bottom: 0;
          opacity: 0;
        }
      }

      @keyframes fadeout {
        from {
          bottom: 30px;
          opacity: 1;
        }
        to {
          bottom: 0;
          opacity: 0;
        }
      }

      .dropbtn {
        background-color: #4caf50;
        color: white;
        padding: 16px;
        font-size: 16px;
        border: none;
        cursor: pointer;
      }

      .dropdown {
        position: relative;
        display: inline-block;
      }

      .dropdown-content {
        position: absolute;
        right: 0;
        background-color: #ddd;
        padding: 8px;
        min-width: 160px;
        box-shadow: 0px 8px 16px 0px rgba(0, 0, 0, 0.2);
        z-index: 10;
      }

      .dropdown-background {
        position: fixed;
        width: 100%;
        height: 100%;
        top: 0px;
        left: 0px;
        z-index: 9;
        background-color: rgba(0, 0, 0, 0.2);
      }

      .dropdown-content a {
        color: black;
        padding: 12px 16px;
        text-decoration: none;
        display: block;
      }

      .dropdown-content a:hover {
        background-color: #f1f1f1;
      }

      .dropdown:hover .dropbtn {
        background-color: #3e8e41;
      }
	</style>
	
    <title>Example</title>
  </head>
  <body>
    <noscript>You need to enable JavaScript to run this app.</noscript>
    <div id="root">loading ...</div>
	<style>
	    @keyframes spin { 
	    100% {
	        transform:rotate(360deg); 
	    } 
	}
    </style>
    <script type="text/babel">
', usedReactComponentsSourceStrings, aSourceCodeString, '
	const ', aJsObjectString, ';
	const ', aArrayString, ';
	const components = examples.map((example, index) => {
        const { componentProps } = example;
        const { parentProps } = example;
        return (
          <div key={`container${index}`} {...parentProps}>
            <', aClassNameString, ' {...componentProps} />
          </div>
        );
      });
      ReactDOM.render(components, document.getElementById("root"));
    </script>
  </body>
</html>'
]

{ #category : #examples }
SBJsComponentReplacement class >> exampleOpenReactClassInSbEditor [
	"Useful if testing with a workspace"

	^ 'sbEditor openMorphInView: (SBJavascript parseAndReplace: ', self exampleReactClassAsString, ')'
]

{ #category : #examples }
SBJsComponentReplacement class >> exampleReactClassAsString [

	^ 'class Car extends React.Component {
 	examples = [{componentProps: {color: "red", kind: "stuff"}, 
				parentProps: {style: {display: "inline-block", backgroundColor: "blue"}}}];
	render(){
		return <h2 style={{color: this.props.color}}>Hi, I am a {this.props.kind}! </h2>;
	}
}'
]

{ #category : #'generate-html' }
SBJsComponentReplacement class >> generateHtmlFileFor: aReactComponentString withClassName: aClassNameString forOptions: aJsArrayString withUsedReactComponents: aOrderedCollection withSharedProps: aJsObjectString [

	| htmlString |
	htmlString := self
		exampleHTMLTemplateFor: aReactComponentString
		forClass: aClassNameString
		withOptions: aJsArrayString
		withUsedReactComponents: aOrderedCollection
		withSharedProps: aJsObjectString.
	FileStream
		forceNewFileNamed: self testHTMLFilePath
		do: [:stream | stream nextPutAll: htmlString]
]

{ #category : #'inline-replacement' }
SBJsComponentReplacement class >> matchComponentExamples: aDictionary do: aBlock [
	<lang: #javascript match: '(class_declaration
    name: (identifier) @class_name
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

	| wholeReactClass reactClassName options sharedOptions |
	wholeReactClass := aDictionary at: 'class'.
	reactClassName := (aDictionary at: 'class_name') contents.
	options := aDictionary at: 'options'.
	sharedOptions := aDictionary at: 'shared_example_props' ifAbsent: [nil].
	
	"First argument: What will be replaced, second argument: With what it will be replaced."
	^ aBlock value: (aDictionary at: 'example_array') value: (self new
		exampleArray: options
		withSharedProps: sharedOptions
		forAComponent: reactClassName
		withComponentNode: wholeReactClass
		url: self testHTMLFileUrl)
]

{ #category : #'inline-replacement' }
SBJsComponentReplacement class >> replacementQuery [
	"Got no better solutution than to keep an extra copy of the query as it cannot be accessed from the pragma that simply."

	^ '(class_declaration
    name: (identifier) @class_name
    body: (class_body
	(field_definition
        	(property_identifier) @shared_example_props_name
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
) @class'
]

{ #category : #'generate-html' }
SBJsComponentReplacement class >> testHTMLFilePath [

	^ '/Users/michael/Desktop/test.html'
]

{ #category : #'generate-html' }
SBJsComponentReplacement class >> testHTMLFileUrl [

	^ 'file://', self testHTMLFilePath
]

{ #category : #accessing }
SBJsComponentReplacement >> componentMemberAboveSelf [

	| componentMembers |
	componentMembers := self owningClass access children third children.
	^ componentMembers at: (componentMembers indexOf: self) - 1 ifAbsent: [nil]
]

{ #category : #replacing }
SBJsComponentReplacement >> exampleArray: aJsArray withSharedProps: aJsObject forAComponent: aComponentNameString withComponentNode: aComponentNode url: aString [

	| aJSArrayWithName wrappedBrowser usedComponentReplacements |
	aJSArrayWithName := 'examples = ', aJsArray sourceString.
	usedComponentReplacements := aComponentNode collectComponentUsageReplacements.
	self class
		generateHtmlFileFor: aComponentNode sourceString
		withClassName: aComponentNameString
		forOptions: aJSArrayWithName
		withUsedReactComponents: usedComponentReplacements
		withSharedProps: aJsObject.
	wrappedBrowser := SBBlock new
		addMorphBack: (SBJsMMBrowserWrapper new
			addMorphBack: (MMBrowserMorph reactOpenOn: aString);
			changeTableLayout;
			hResizing: #shrinkWrap;
			vResizing: #shrinkWrap;
			yourself);
		addMorphBack: (self savePaletteButtonFor: aComponentNode withName: aComponentNameString);
		changeTableLayout;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		yourself.
	
	self
		listDirection: #topToBottom;
		addMorphBack: (SBRow new
			addMorphBack: wrappedBrowser;
			addMorphBack: aJsArray buildCopy)
]

{ #category : #accessing }
SBJsComponentReplacement >> exampleArraySandblock [

	| rowSubmorphs |
	rowSubmorphs := self firstSubmorph submorphs.
	^ rowSubmorphs size > 1
		ifTrue: [rowSubmorphs second firstSubmorph]
		ifFalse: [rowSubmorphs first]
]

{ #category : #accessing }
SBJsComponentReplacement >> firstValidExampleComponentProps [

	self flag: #TODO.
	"Reassess whether needed here in the future or only in SBJsComponentUsageReplacement"
	^ self exampleArraySandblock access children
		detect: [:exampleObject |
			(exampleObject children
				detect: [:entry |
					entry key contents = 'componentProps'
						ifTrue: [^ entry value]
						ifFalse: [false]]
				ifNone: [false]) notNil]
		ifNone: [self error: (Error signal: 'Could not find a object in the examples array with ''componentProps'' being set.')]
]

{ #category : #accessing }
SBJsComponentReplacement >> firstValidExampleKeyValuePairs [

	self flag: #TODO.
	"Reassess whether needed here in the future or only in SBJsComponentUsageReplacement"
	^ (self firstValidExampleComponentProps children reject: [:objectEntry | objectEntry type ~= 'pair']) collect: [:keyValuePair | keyValuePair key contents -> keyValuePair value]
]

{ #category : #accessing }
SBJsComponentReplacement >> initialize [

	super initialize.
	self skipHtmlFileGeneration: false
]

{ #category : #accessing }
SBJsComponentReplacement >> owningClass [

	| currentOwner |
	currentOwner := self owner.
	[currentOwner type ~= 'class_declaration'] whileTrue: [currentOwner := currentOwner owner].
	^ currentOwner
]

{ #category : #replacing }
SBJsComponentReplacement >> savePaletteButtonFor: aComponentNode withName: aComponentNameString [

	^ SBButton new icon: SBIcon iconSave label: 'Save to Palette' do: [ | category componentUsageReplacement |
		category := UIManager default
			chooseFromOrAddTo: SBJsReactComponentRegistry defaultRegistry allCategories
			lines: nil
			title: 'Choose Category'.
		category ifNotNil: [
			Cursor wait showWhile: [
				componentUsageReplacement := SBJsComponentUsageReplacement inlineComponentUsageReplacementFor: self owningClass sourceString.
				SBJsReactComponentRegistry defaultRegistry
					addComponent: componentUsageReplacement
					withName: aComponentNameString
					inCategory: category]]]
]

{ #category : #accessing }
SBJsComponentReplacement >> sharedExampleProps [

	self componentMemberAboveSelf ifNotNil: [:memberAbove | memberAbove access children first contents = 'sharedExampleProps' ifTrue: [^ memberAbove]].
	^ nil
]

{ #category : #accessing }
SBJsComponentReplacement >> skipHtmlFileGeneration [

	^ skipHtmlFileGeneration
]

{ #category : #accessing }
SBJsComponentReplacement >> skipHtmlFileGeneration: aBoolean [

	skipHtmlFileGeneration := aBoolean
]

{ #category : #saving }
SBJsComponentReplacement >> veryDeepCopyWith: deepCopier [

	| new mmBrowserMorph row |
	" assure that the browser morph is not included in the deepCopy; Does not seem to work :/ "
	row := self firstSubmorph.
	mmBrowserMorph := row firstSubmorph.
	row removeMorph: mmBrowserMorph.
	new := super veryDeepCopyWith: deepCopier.
	row addMorphFront: mmBrowserMorph.
	
	^ new
]

{ #category : #saving }
SBJsComponentReplacement >> writeSourceOn: aStream [

	| optionsObject |
	optionsObject := 'examples = ', self exampleArraySandblock sourceString.
	aStream nextPutAll: optionsObject.
	self skipHtmlFileGeneration ifFalse: [ | className componentClass usedComponentReplacements sharedExampleProps |
		self skipHtmlFileGeneration: true.
		componentClass := self owningClass.
		className := componentClass firstSubmorph submorphs third contents.
		usedComponentReplacements := componentClass collectComponentUsageReplacements.
		sharedExampleProps := self sharedExampleProps.
		self class
			generateHtmlFileFor: componentClass sourceString
			withClassName: className
			forOptions: optionsObject
			withUsedReactComponents: usedComponentReplacements
			withSharedProps: sharedExampleProps.
		self firstSubmorph firstSubmorph firstSubmorph firstSubmorph doRefresh.
		self skipHtmlFileGeneration: false]
]
