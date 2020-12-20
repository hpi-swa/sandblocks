as yet unclassified
postDrawOn: aCanvas

	| b color |
	self cursorVisible ifFalse: [^ self].
	b := self morph bounds expandBy: 2.
	color := self morph colorPolicy selectionColorForBlock: (self morph parentSandblock ifNil: [self morph]).
	
	self morph sandblockEditor mode = #input
		ifTrue: [
			aCanvas line: b bottomLeft to: b bottomRight width: self morph frameSize color: color]
		ifFalse: [
			aCanvas frameRectangle: b width: self morph frameSize color: color]