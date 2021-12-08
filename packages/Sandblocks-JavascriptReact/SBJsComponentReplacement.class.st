Class {
	#name : #SBJsComponentReplacement,
	#superclass : #SBInlineBlockReplace,
	#instVars : [
		'skipHtmlFileGeneration'
	],
	#category : #'Sandblocks-JavascriptReact'
}

{ #category : #'as yet unclassified' }
SBJsComponentReplacement class >> exampleHTMLTemplateFor: aSourceCodeString forClass: aClassNameString withOptions: aObjectString [

	^ '<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta name="theme-color" content="#000000" />

    <meta
      name="description"
      content="Web site created using create-react-app"
    />
    <title>Example</title>
  </head>
  <body>
    <noscript>You need to enable JavaScript to run this app.</noscript>
    <div id="root">loading ...</div>
    <script src="https://unpkg.com/react@17.0.2/umd/react.production.min.js"></script>
    <script src="https://unpkg.com/react-dom@17/umd/react-dom.production.min.js"></script>
    <script src="https://unpkg.com/babel-standalone@6/babel.min.js"></script>
	<style>
	    @keyframes spin { 
	    100% {
	        transform:rotate(360deg); 
	    } 
	}
    </style>
    <script type="text/babel">
',
	aSourceCodeString,
	'
	const ', aObjectString, ';
	const { componentProps } = example;
	const { parentProps } = example;
	ReactDOM.render(<div id="container" {...parentProps}></div>, document.getElementById("root"));
	ReactDOM.render(<' , aClassNameString , ' {...componentProps} />, document.getElementById("container"));
    </script>
  </body>
</html>'
	
]

{ #category : #'as yet unclassified' }
SBJsComponentReplacement class >> getTestHTMLFilePath [

	 ^ '/Users/michael/Desktop/test.html'
]

{ #category : #'as yet unclassified' }
SBJsComponentReplacement class >> getTestHTMLFileUrl [

	 ^ 'file://', self getTestHTMLFilePath
]

{ #category : #'as yet unclassified' }
SBJsComponentReplacement class >> matchJs: aDictionary do: aBlock [
	<lang: #javascript match: '(class_declaration
    name: (identifier) @class_name
    body: (class_body
    	(field_definition
        	(property_identifier) @example_name
	      (object) @options
        ) @example_object
	(method_definition
        	(property_identifier) @method_name
  	)
    )
) @class'>
	| wholeReactClass reactClassName options wholeOptions  |
	(aDictionary at: 'example_name') contents = 'example' ifFalse: [^ nil].
	(aDictionary at: 'method_name') contents = 'render' ifFalse: [^ nil].
	wholeReactClass := aDictionary at: 'class'. 
	reactClassName := (aDictionary at: 'class_name') contents.
	options := (aDictionary at: 'options').
	wholeOptions := (aDictionary at: 'example_object').
	
	"First argument: What will be replaced, second argument: With what it will be replaced."
	 ^ aBlock
		value: (aDictionary at: 'example_object')
		value: (self new exampleObject: wholeOptions forAComponent: reactClassName withComponentNode: wholeReactClass url: self getTestHTMLFileUrl
		)
		
	

]

{ #category : #'as yet unclassified' }
SBJsComponentReplacement class >> sampleReactClassAsString [

	 ^ 'class Car extends React.Component {
 	example = {};
	render(){
		return <h2>Hi, I am a Car! </h2>;
	}
}'
]

{ #category : #'as yet unclassified' }
SBJsComponentReplacement >> exampleObject: aJsObject forAComponent: aComponentNameString withComponentNode: aComponentNode url: aString [ 
	
	self generateHtmlFileFor: aComponentNode sourceString withClassName: aComponentNameString  forOptions: aJsObject sourceString.
	self
		listDirection: #topToBottom;
		addMorphBack: (SBRow new
			addMorphBack: (MMBrowserMorph reactOpenOn: aString);
			addMorphBack: aJsObject buildCopy).
			"addMorphBack: (SBTextBubble new contents: aString))"
		
	

]

{ #category : #'as yet unclassified' }
SBJsComponentReplacement >> generateHtmlFileFor: aReactComponentString withClassName: aClassNameString forOptions: aJsObjectString [

	| htmlString |
	htmlString := self class exampleHTMLTemplateFor: aReactComponentString forClass: aClassNameString withOptions: aJsObjectString.
	"Hotfix for source code generation"
	htmlString := htmlString copyReplaceAll: 'h2style' with: 'h2 style'.
	FileStream forceNewFileNamed: self class getTestHTMLFilePath do: [:stream | stream nextPutAll: htmlString].
		
	

]

{ #category : #'as yet unclassified' }
SBJsComponentReplacement >> getOwningClass [

	| currentOwner |
	currentOwner := self owner.
	[currentOwner type ~= 'class_declaration'] whileTrue: [currentOwner := currentOwner owner].
	^ currentOwner.
]

{ #category : #accessing }
SBJsComponentReplacement >> initialize [

	super initialize.
	self skipHtmlFileGeneration: false.
]

{ #category : #accessing }
SBJsComponentReplacement >> skipHtmlFileGeneration [

	^ skipHtmlFileGeneration
]

{ #category : #accessing }
SBJsComponentReplacement >> skipHtmlFileGeneration: aBoolean [

	skipHtmlFileGeneration := aBoolean.
]

{ #category : #'as yet unclassified' }
SBJsComponentReplacement >> writeSourceOn: aStream [

      | optionsObject |
	optionsObject :=  self firstSubmorph submorphs second firstSubmorph sourceString , ';'.
	aStream nextPutAll: optionsObject.
	self skipHtmlFileGeneration ifFalse: [
		| className componentClass |
		self skipHtmlFileGeneration: true.
		componentClass := self getOwningClass.
		className := componentClass firstSubmorph submorphs third contents.
		self generateHtmlFileFor: componentClass sourceString withClassName: className forOptions: optionsObject.
		self firstSubmorph firstSubmorph doRefresh.
		self skipHtmlFileGeneration: false
	]
]
