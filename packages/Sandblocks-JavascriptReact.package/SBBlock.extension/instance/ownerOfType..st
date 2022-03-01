*Sandblocks-JavascriptReact
ownerOfType: aString

	| currentOwner |
	currentOwner := self owner.
	[currentOwner type ~= aString] whileTrue: [currentOwner := currentOwner owner].
	^ currentOwner type = aString ifTrue: [currentOwner] ifFalse: [nil]