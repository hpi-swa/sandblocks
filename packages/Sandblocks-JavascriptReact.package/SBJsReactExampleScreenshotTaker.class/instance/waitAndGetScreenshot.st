screenshot-taking
waitAndGetScreenshot

	self notifyGotScreenshotSemaphore wait.
	^ self screenshot