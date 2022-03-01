A SBJsExampleScreenshotTaker is a class to take screenshots of a given React Component via a SBJsReactComponentWrapper.
Taking a screenshot works by generating a html file for the given component using the SBJsReactExamplesReplacement's html generation class function. Then the MMProcessWrapper is asked to take a screenshot of the examples rendered of the component for an instance of the SBJsExampleScreenshotTaker. As taking the screenshot is asynchronous the notifyGotScreenshotSemaphore is used to wait until the screenshot was taken. After the screenshot is taken it is returned. This is all this class is used for in this package.

Note that this halts the process while the screenshot is taken. 
Note that instances of this class implement the interface of the MMBrowserMorph so that they can be registered at the MMProcessWrapper as a pseudo browser. This makes it easier to obtain the screenshot taken by MagicMouse than using an instrumented MMBrowserMorph.

Instance Variables
	notifyGotScreenshotSemaphore:		<Semaphore>
	screenshot:		<Form>

notifyGotScreenshotSemaphore
	- A semaphore to wait until the screenshot was taken and stored in the screenshot instance variable.

screenshot
	- Stores the screenshot taken of the component example.


Interesting points where to start:
- The onliest interesting method of this class is the takeScreenshotOf:withExample:withExtent: class method which is responsible for taking a screenshot accodring to the supplied parameters.