initialize-release
openInWindow

	| window |
	window := self embeddedInMorphicWindowLabeled: self labelString.
	window model: self.
	
	window := window openInWorldExtent: self extent.
	(Project uiManager openToolsAttachedToMouseCursor)
		ifTrue: [
			window setProperty: #initialDrop toValue: true.
			window hasDropShadow: false.
			self currentHand attachMorph: window].
	^ window