accessing
count: aNumber

	count := aNumber.
	count > 1 ifTrue: [
		countLabel disableLayout: false; visible: true; contents: aNumber asString]