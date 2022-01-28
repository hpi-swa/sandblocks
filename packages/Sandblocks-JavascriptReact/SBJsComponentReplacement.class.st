Class {
	#name : #SBJsComponentReplacement,
	#superclass : #SBInlineBlockReplace,
	#instVars : [
		'skipHtmlFileGeneration'
	],
	#category : #'Sandblocks-JavascriptReact'
}

{ #category : #'as yet unclassified' }
SBJsComponentReplacement class >> exampleHTMLTemplateFor: aSourceCodeString forClass: aClassNameString withOption: aObjectString [

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
', aSourceCodeString, '
	const ', aObjectString, ';
	const { componentProps } = example;
	const { parentProps } = example;
	ReactDOM.render(<div id="container" {...parentProps}></div>, document.getElementById("root"));
	ReactDOM.render(<', aClassNameString, ' {...componentProps} />, document.getElementById("container"));
    </script>
  </body>
</html>'
]

{ #category : #'as yet unclassified' }
SBJsComponentReplacement class >> exampleHTMLTemplateFor: aSourceCodeString forClass: aClassNameString withOptions: aArrayString [

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
', aSourceCodeString, '
	const ', aArrayString, ';
	const components = examples.map((example, index) => {
        debugger;
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

{ #category : #'as yet unclassified' }
SBJsComponentReplacement class >> exampleHTMLTemplateFor: aSourceCodeString forClass: aClassNameString withOptions: aArrayString withSharedProps: aJsObjectString [

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
', aSourceCodeString, '
	const ', aJsObjectString, ';
	const ', aArrayString, ';
	const components = examples.map((example, index) => {
        debugger;
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

{ #category : #'as yet unclassified' }
SBJsComponentReplacement class >> generateHtmlFileFor: aReactComponentString withClassName: aClassNameString forOptions: aJsArrayString [

	| htmlString |
	htmlString := self
		exampleHTMLTemplateFor: aReactComponentString
		forClass: aClassNameString
		withOptions: aJsArrayString.
	FileStream
		forceNewFileNamed: self getTestHTMLFilePath
		do: [:stream | stream nextPutAll: htmlString]
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
SBJsComponentReplacement class >> isMatchCorrect: aDictionary [

	^ (aDictionary at: 'examples_name') contents = 'examples'
		and: [(aDictionary at: 'method_name') contents = 'render']
		and: [(aDictionary at: 'shared_example_props_name' ifAbsent: ['sharedExampleProps']) = 'sharedExampleProps']
]

{ #category : #'as yet unclassified' }
SBJsComponentReplacement class >> matchComponentExamples: aDictionary do: aBlock [
	<lang: #javascript match: '(class_declaration
    name: (identifier) @class_name
    body: (class_body
	(field_definition
        	(property_identifier) @shared_example_props_name
	      (object)
        )? @shared_example_props
    	(field_definition
        	(property_identifier) @examples_name
	      (array) @options
        ) @example_array
	(method_definition
        	(property_identifier) @method_name
  	)
    )
) @class'>

	| wholeReactClass reactClassName options sharedOptions |
	(self isMatchCorrect: aDictionary) ifFalse: [^ nil].
	(aDictionary at: 'method_name') contents = 'render' ifFalse: [^ nil].
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
		url: self getTestHTMLFileUrl)
]

{ #category : #'as yet unclassified' }
SBJsComponentReplacement class >> replacementQuery [

	^ '(class_declaration
    name: (identifier) @class_name
    body: (class_body
    	(field_definition
        	(property_identifier) @examples_name
	      (array) @options
        ) @example_array
	(method_definition
        	(property_identifier) @method_name
  	)
    )
) @class'
]

{ #category : #'as yet unclassified' }
SBJsComponentReplacement class >> sampleOpenReactClassInSbEditor [

	^ 'sbEditor openMorphInView: (SBJavascript parseAndReplace: ', self sampleReactClassAsString, ')'
]

{ #category : #'as yet unclassified' }
SBJsComponentReplacement class >> sampleReactClassAsString [

	^ 'class Car extends React.Component {
 	examples = [{componentProps: {color: "red", kind: "stuff"}, 
				parentProps: {style: {display: "inline-block", backgroundColor: "blue"}}}];
	render(){
		return <h2 style={{color: this.props.color}}>Hi, I am a {this.props.kind}! </h2>;
	}
}'
]

{ #category : #'as yet unclassified' }
SBJsComponentReplacement >> componentSourceWithSingleExample: aStream [

	| optionsObject |
	optionsObject := 'examples = ', self exampleArraySandblock sourceString, ';'.
	aStream nextPutAll: optionsObject.
	self skipHtmlFileGeneration ifFalse: [ | className componentClass |
		self skipHtmlFileGeneration: true.
		componentClass := self owningClass.
		className := componentClass firstSubmorph submorphs third contents.
		self class
			generateHtmlFileFor: componentClass sourceString
			withClassName: className
			forOptions: optionsObject.
		self firstSubmorph firstSubmorph firstSubmorph doRefresh.
		self skipHtmlFileGeneration: false]
]

{ #category : #'as yet unclassified' }
SBJsComponentReplacement >> exampleArray: aJsArray forAComponent: aComponentNameString withComponentNode: aComponentNode url: aString [

	| aJSArrayWithName wrappedBrowser |
	aJSArrayWithName := 'examples = ', aJsArray sourceString.
	self class
		generateHtmlFileFor: aComponentNode sourceString
		withClassName: aComponentNameString
		forOptions: aJSArrayWithName.
	wrappedBrowser := SBBlock new
		attachDecorator: SBResizableDecorator new;
		addMorphBack: (MMBrowserMorph reactOpenOn: aString);
		color: Color seaFoam;
		changeTableLayout;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		yourself.
	wrappedBrowser addMorphBack: (SBButton new icon: SBIcon iconSave label: 'Save to Palette' do: [ | str temp |
		str := '<', aComponentNameString.
		temp := aJsArray.
		self halt.
		
		]).
	self
		listDirection: #topToBottom;
		addMorphBack: (SBRow new
			addMorphBack: wrappedBrowser;
			addMorphBack: aJsArray buildCopy)
	"addMorphBack: (SBTextBubble new contents: aString))"
]

{ #category : #'as yet unclassified' }
SBJsComponentReplacement >> exampleArray: aJsArray withSharedProps: aJsObject forAComponent: aComponentNameString withComponentNode: aComponentNode url: aString [

	| aJSArrayWithName wrappedBrowser |
	aJSArrayWithName := 'examples = ', aJsArray sourceString.
	self class
		generateHtmlFileFor: aComponentNode sourceString
		withClassName: aComponentNameString
		forOptions: aJSArrayWithName.
	"withSharedProps: (aJsObject ifNotNil: [:object | object sourceString] ifNil: ['sharedExampleProps = {}'])."
	wrappedBrowser := SBBlock new
		attachDecorator: SBResizableDecorator new;
		addMorphBack: ((MMBrowserMorph reactOpenOn: aString) hResizing: #spaceFill; vResizing: #spaceFill; minimumExtent: 50@50);
		addMorphBack: (SBButton new icon: SBIcon iconSave label: 'Save to Palette' do: [ | temp |
			temp := SBJsComponentUsageReplacement inlineComponentUsageReplacementFor: aComponentNode sourceString.
			SBJsReactComponentRegistry defaultRegistry addComponent: temp withName: aComponentNameString]);
		color: Color seaFoam;
		changeTableLayout;
		hResizing: #rigid;
		vResizing: #rigid;
		extent: 190@170;
		yourself.
	
	self
		listDirection: #topToBottom;
		addMorphBack: (SBRow new
			addMorphBack: wrappedBrowser;
			addMorphBack: aJsArray buildCopy)
	"addMorphBack: (SBTextBubble new contents: aString))"
]

{ #category : #'as yet unclassified' }
SBJsComponentReplacement >> exampleArraySandblock [

	^ self firstSubmorph submorphs second firstSubmorph
]

{ #category : #'as yet unclassified' }
SBJsComponentReplacement >> firstValidExampleComponentProps [

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

{ #category : #'as yet unclassified' }
SBJsComponentReplacement >> firstValidExampleKeyValuePairs [

	| temp |
	temp := (self firstValidExampleComponentProps children reject: [:objectEntry | objectEntry type ~= 'pair']) collect: [:keyValuePair | keyValuePair key contents -> keyValuePair value].
	^ temp
]

{ #category : #accessing }
SBJsComponentReplacement >> initialize [

	super initialize.
	self skipHtmlFileGeneration: false
]

{ #category : #'as yet unclassified' }
SBJsComponentReplacement >> owningClass [

	| currentOwner |
	currentOwner := self owner.
	[currentOwner type ~= 'class_declaration'] whileTrue: [currentOwner := currentOwner owner].
	^ currentOwner
]

{ #category : #accessing }
SBJsComponentReplacement >> skipHtmlFileGeneration [

	^ skipHtmlFileGeneration
]

{ #category : #accessing }
SBJsComponentReplacement >> skipHtmlFileGeneration: aBoolean [

	skipHtmlFileGeneration := aBoolean
]

{ #category : #'as yet unclassified' }
SBJsComponentReplacement >> veryDeepCopyWith: deepCopier [

	| new row mmBrowserMorph |
	" assure that the browser morph is not included in the deepCopy "
	row := self firstSubmorph.
	mmBrowserMorph := row firstSubmorph.
	row removeMorph: mmBrowserMorph.
	new := super veryDeepCopyWith: deepCopier.
	row addMorphFront: mmBrowserMorph.
	
	^ new
]

{ #category : #'as yet unclassified' }
SBJsComponentReplacement >> writeSourceOn: aStream [

	| optionsObject |
	optionsObject := 'examples = ', self exampleArraySandblock sourceString.
	aStream nextPutAll: optionsObject.
	self skipHtmlFileGeneration ifFalse: [ | className componentClass |
		self skipHtmlFileGeneration: true.
		componentClass := self owningClass.
		className := componentClass firstSubmorph submorphs third contents.
		self class
			generateHtmlFileFor: componentClass sourceString
			withClassName: className
			forOptions: optionsObject.
		self firstSubmorph firstSubmorph firstSubmorph doRefresh.
		self skipHtmlFileGeneration: false]
]
