*Sandblocks-Core
mouseLeaveHighlight

	self valueOfProperty: #morphHighlightPopup ifPresentDo: [:popup |
		popup delete.
		self removeProperty: #morphHighlightPopup]