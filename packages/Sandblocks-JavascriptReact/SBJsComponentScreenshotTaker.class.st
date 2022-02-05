"
A SBJsComponentScreenshotTaker is a class to take screenshots of a given React Component. The screenshots can be take with the takeScreenshotOf:atExample:withExtent: method. This should be the onliest method how this class should be used. The rest is solely to handle taking the screenshot.
Taking a screenshot works by using generating a html file for the given component similar to the way the SBJsComponentReplacement does it. Then the MMProcessWrapper is asked to take a screenshot of the examples rendered of the component for a instance of the SBJsComponentScreenshotTaker. As taking the screenshot is asynchonous the notifyGotScreenshotSemaphore is used to wait until the screenshot was taken. Then it can be access from the created instance of SBJsComponentScreenshotTaker via the instance variable screenshot.

Instance Variables
	notifyGotScreenshotSemaphore:		<Semaphore>
	screenshot:		<Form>

notifyGotScreenshotSemaphore
	- A semaphore to wait until the screenshot was taken and stored in the screenshot instance varible.

screenshot
	- Stores the screenshot taken of the component examples.

"
Class {
	#name : #SBJsComponentScreenshotTaker,
	#superclass : #Object,
	#instVars : [
		'notifyGotScreenshotSemaphore',
		'screenshot'
	],
	#category : #'Sandblocks-JavascriptReact'
}

{ #category : #'screenshot-taking' }
SBJsComponentScreenshotTaker class >> takeScreenshotOf: aReactComponentString atExample: index withExtent: aPoint [

	| reactComponentAST |
	reactComponentAST := SBJavascript parse: aReactComponentString.
	self flag: #TODO.
	"index ist currently ignored"
	reactComponentAST allBlocksDo: [:block |
		SBTSQuery new execute: SBJsComponentReplacement replacementQuery against: block capturesDo: [:captures :success |
			success  ifTrue: [ | reactClassName wholeReactClass optionsWithName instance tabId screenshot |
				instance := self new.
				wholeReactClass := (captures at: 'class') sourceString.
				reactClassName := (captures at: 'class_name') contents.
				optionsWithName := 'examples = ', (captures at: 'options') sourceString.
				SBJsComponentReplacement
					generateHtmlFileFor: wholeReactClass
					withClassName: reactClassName
					forOptions: optionsWithName.
				tabId := MMProcessWrapper getOSDependentSingleton
					takeScreenshotAt: SBJsComponentReplacement testHTMLFileUrl
					withExtend: aPoint
					for: instance.
				screenshot := instance waitAndGetScreenshot.
				MMProcessWrapper getOSDependentSingleton closeTab: tabId.
				screenshot := screenshot trimBordersOfColor: Color white.
				^ screenshot]]].
	self error: 'Looks like there is no matching examples array in the component.'
]

{ #category : #testing }
SBJsComponentScreenshotTaker class >> test [

	self flag: #TODO.
	"Try to make this an SBExample"
	[:sbEditor |
		sbEditor openMorphInView: (ImageMorph new image: (self
			takeScreenshotOf: SBJsComponentReplacement exampleReactClassAsString
			atExample: 0
			withExtent: 300 @ 300))]
]

{ #category : #testing }
SBJsComponentScreenshotTaker class >> test: sbEditor [

	self flag: #TODO.
	"Try to make this an SBExample"
	[ | morphy |
		morphy := ImageMorph new.
		sbEditor openMorphInView: morphy.
		morphy image: (self
			takeScreenshotOf: SBJsComponentReplacement exampleReactClassAsString
			atExample: 0
			withExtent: 300 @ 300)] fork
]

{ #category : #'ignored-mm-events' }
SBJsComponentScreenshotTaker >> handleFormFields: payload [
	"Ignoring possible event send by MagicMouse"

	
]

{ #category : #'ignored-mm-events' }
SBJsComponentScreenshotTaker >> handleGitClone: payload [
	"Ignoring possible event send by MagicMouse"

	
]

{ #category : #'ignored-mm-events' }
SBJsComponentScreenshotTaker >> handlePortal: payload [
	"Ignoring possible event send by MagicMouse"

	
]

{ #category : #'ignored-mm-events' }
SBJsComponentScreenshotTaker >> handleStructuredData: payload [
	"Ignoring possible event send by MagicMouse"

	
]

{ #category : #accessing }
SBJsComponentScreenshotTaker >> initialize [

	super initialize.
	self notifyGotScreenshotSemaphore: Semaphore new
]

{ #category : #'ignored-mm-events' }
SBJsComponentScreenshotTaker >> locationUpdated: payload [
	"Ignoring possible event send by MagicMouse"

	
]

{ #category : #accessing }
SBJsComponentScreenshotTaker >> notifyGotScreenshotSemaphore [

	^ notifyGotScreenshotSemaphore
]

{ #category : #accessing }
SBJsComponentScreenshotTaker >> notifyGotScreenshotSemaphore: aSemaphore [

	notifyGotScreenshotSemaphore := aSemaphore
]

{ #category : #accessing }
SBJsComponentScreenshotTaker >> screenshot [

	^ screenshot
]

{ #category : #accessing }
SBJsComponentScreenshotTaker >> screenshot: aForm [

	screenshot := aForm
]

{ #category : #'screenshot-taking' }
SBJsComponentScreenshotTaker >> updateImage: payload [

	| form |
	form := MMBrowserMorph parseImage: payload into: (Form extent: 1 @ 1).
	self screenshot: form.
	self notifyGotScreenshotSemaphore signal
]

{ #category : #'screenshot-taking' }
SBJsComponentScreenshotTaker >> waitAndGetScreenshot [

	self notifyGotScreenshotSemaphore wait.
	^ self screenshot
]
