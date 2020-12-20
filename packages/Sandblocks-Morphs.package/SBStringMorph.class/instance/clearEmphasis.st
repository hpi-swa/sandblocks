accessing
clearEmphasis

	self flag: #fixme. " the stringmorph API is a little borked when it comes to clearing format "
	emphasis := 0.
	font := nil.
	self emphasis: 0