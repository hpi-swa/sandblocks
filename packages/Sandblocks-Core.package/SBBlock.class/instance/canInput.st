actions
canInput

	self flag: #fixme.
	" see if we specialize startInput. FIXME: we can currently not just call startInput and
	see what we get back because some classes cause side-effects, which they shouldn't "
	^ (self class lookupSelector: #startInputAt:replacingContents:) methodClass ~= SBBlock