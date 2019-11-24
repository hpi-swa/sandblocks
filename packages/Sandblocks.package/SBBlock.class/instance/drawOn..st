as yet unclassified
drawOn: aCanvas

	"aCanvas fillRectangle: self bounds color: self color."
	| editor |
	aCanvas
		frameAndFillRectangle: self bounds
		fillColor: self drawnColor
		borderWidth: (self colorPolicy borderWidthForBlock: self) 
		borderColor: (self colorPolicy borderColorForBlock: self).
	
	self prefix ifNotNil: [:p | self drawPrefix: p on: aCanvas].
	
	editor := self sandblockEditor.
	self marked ifTrue: [self drawFrame: Color yellow on: aCanvas].
	editor multiSelection do: [:morph |
		morph = self ifTrue: [self drawFrame: ((morph parentSandblock ifNil: [morph]) foregroundColor alpha: 0.6) on: aCanvas]].
	editor selection = self ifTrue: [self drawFrame: (self parentSandblock ifNil: [self]) foregroundColor on: aCanvas]