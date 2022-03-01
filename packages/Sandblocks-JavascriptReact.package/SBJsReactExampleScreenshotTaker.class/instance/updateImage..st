screenshot-taking
updateImage: payload

	| form |
	form := MMBrowserMorph parseImage: payload into: (Form extent: 1 @ 1).
	self screenshot: form.
	self notifyGotScreenshotSemaphore signal