*Sandblocks-Core
onHoverHighlight: aMorph labeled: aString

	aMorph isMorph ifFalse: [^ self].
	
	self balloonText: aString.
	self setProperty: #highlightMorphSubject toValue: aMorph.
	self on: #mouseEnter send: #mouseEnterHighlight to: self.
	self on: #mouseLeave send: #mouseLeaveHighlight to: self