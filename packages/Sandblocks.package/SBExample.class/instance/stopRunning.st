as yet unclassified
stopRunning

	self stopSteppingSelector: #run.
	active := false.
	self updateIcon