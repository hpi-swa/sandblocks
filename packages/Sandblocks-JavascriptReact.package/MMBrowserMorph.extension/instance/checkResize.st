*Sandblocks-JavascriptReact
checkResize

	| rect newExtent |
	rect := self image rectangleEnclosingPixelsNotOfColor: Color white.
	newExtent := rect bottomRight + rect topLeft.
	self extent: (rect bottomRight + rect topLeft max: 75 @ 75)