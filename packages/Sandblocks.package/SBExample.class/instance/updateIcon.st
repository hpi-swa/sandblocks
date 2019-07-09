as yet unclassified
updateIcon

	icon changeIconName: ((self isSteppingSelector: #run)
		ifTrue: [#iconPause] ifFalse: [#iconPlay])