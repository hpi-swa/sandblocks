"
A SBJsComponentScreenshotTaker is a class to take screenshots of a given React Component via a SBJSReactComponentWrapper.
Taking a screenshot works by generating a html file for the given component similar using the methods of SBJsComponentReplacement. Then the MMProcessWrapper is asked to take a screenshot of the examples rendered of the component for a instance of the SBJsComponentScreenshotTaker. As taking the screenshot is asynchonous the notifyGotScreenshotSemaphore is used to wait until the screenshot was taken. Note that this halts the process. After the screenshot is taken it is returned.
Note that instances of this class implement the interface of the MMBrowserMorph so that they can be registered at the MMProcessWrapper as a pseudo browser. This makes it easier to optain the screenshot taken by MagicMouse.

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
SBJsComponentScreenshotTaker class >> takeScreenshotOf: aSBJsReactComponentWrapper withExample: aJsObject withExtent: aPoint [

	| tabId filePath screenshot instance |
	instance := self new.
	filePath := SBJsComponentReplacement testHTMLFileDir, 'Screenshot_temp.html'.
	SBJsComponentReplacement
		generateHtmlFileForExample: aJsObject
		withCaptures: aSBJsReactComponentWrapper
		atFilePath: filePath.
	self flag: #TODO.
	"Consider Tom's feedback about the interface how to take the screenshot."
	tabId := MMProcessWrapper getOSDependentSingleton
		takeScreenshotAt: (SBJsComponentReplacement filePathToURL: filePath)
		withExtend: aPoint
		for: instance.
	screenshot := instance waitAndGetScreenshot.
	MMProcessWrapper getOSDependentSingleton closeTab: tabId.
	screenshot := screenshot trimBordersOfColor: Color white.
	^ screenshot
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
