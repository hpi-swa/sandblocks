as yet unclassified
handlesMouseDown: anEvent

	^ self endPointsDo: [:start :end |
		anEvent position onLineFrom: start to: end within: 10]