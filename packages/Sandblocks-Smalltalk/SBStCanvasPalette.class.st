Class {
	#name : #SBStCanvasPalette,
	#superclass : #SBPalette,
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #'as yet unclassified' }
SBStCanvasPalette class >> buildOn: aContainer [

	aContainer
		addHeader: 'Canvas';
		
		addSectionHeader: 'Primitives';
		addBlock: 'Line'
			as: (SBStMessageSend new
				receiver: (SBStName contents: 'aCanvas')
				selector: #line:to:width:color:
				arguments: {
					self newNullBlock: 'from'.
					self newNullBlock: 'to'.
					self newNullBlock: 'width'.
					SBColor new colorContents: Color red
				});
		addBlock: 'Fill Rectangle'
			as: (SBStMessageSend new
				receiver: (SBStName contents: 'aCanvas')
				selector: #fillRectangle:color:
				arguments: {self newNullBlock: 'rect'. SBColor new colorContents: Color red});
		addBlock: 'Frame Rectangle'
			as: (SBStMessageSend new
				receiver: (SBStName contents: 'aCanvas')
				selector: #frameRectangle:width:color:
				arguments: {self newNullBlock: 'rect'. self newNullBlock: 'width'. SBColor new colorContents: Color red});
		addBlock: 'Fill Oval'
			as: (SBStMessageSend new
				receiver: (SBStName contents: 'aCanvas')
				selector: #fillOval:color:
				arguments: {self newNullBlock: 'rect'. SBColor new colorContents: Color red});
		addBlock: 'Frame Oval'
			as: (SBStMessageSend new
				receiver: (SBStName contents: 'aCanvas')
				selector: #frameOval:width:color:
				arguments: {self newNullBlock: 'rect'. self newNullBlock: 'width'. SBColor new colorContents: Color red});
		addSectionHeader: 'Data';
		addBlock: 'Rectangle Extent'
			as: (SBStMessageSend new receiver: (self newNullBlock: 'origin') selector: #extent: arguments: {self newNullBlock: 'extent'});
		addBlock: 'Rectangle Corner'
			as: (SBStMessageSend new receiver: (self newNullBlock: 'origin') selector: #corner: arguments: {self newNullBlock: 'corner'});
		addBlock: 'Point'
			as: (SBStMessageSend new receiver: (self newNullBlock: 'x') selector: #@ arguments: {self newNullBlock: 'y'});
		addBlock: 'Point Projection' as: (SBPoint newForPoint: 0 @ 0);
		addBlock: 'Position' as: (SBStMessageSend new receiver: (SBStName contents: 'self') selector: #position);
		addBlock: 'Bounds' as: (SBStMessageSend new receiver: (SBStName contents: 'self') selector: #bounds);
		addBlock: 'Color' as: (SBStMessageSend new receiver: (SBStName contents: 'self') selector: #color);
		
		addSectionHeader: 'Transforms';
		addBlock: 'Translate'
			as: (SBStMessageSend new
				receiver: (SBStName contents: 'aCanvas')
				selector: #translateBy:during:
				arguments: {self newNullBlock: 'offset'. SBStBlockBody emptyWithDeclarations: {'canvas'}});
		
		addSectionHeader: 'Styles';
		addBlock: 'Color' as: (SBColor new colorContents: Color green);
		addBlock: 'Gradient' as: '(GradientFillStyle colors: {Color red. Color green}) origin: self position; direction: 0 @ self height' parseAsSandblock
]

{ #category : #'as yet unclassified' }
SBStCanvasPalette class >> context [

	^ {#isSmalltalk. [:b | b containingArtefact satisfies: {#notNil. #isMethod. #isSmalltalk. [:a | a arguments contains: [:arg | arg contents = 'aCanvas']]}]}
]

{ #category : #'as yet unclassified' }
SBStCanvasPalette class >> grammarHandler [

	^ SBStGrammarHandler new
]

{ #category : #'as yet unclassified' }
SBStCanvasPalette class >> matchesBlock: aBlock [

	self example: [SBStCanvasPalette] args: [{(Morph >> #drawOn:) asSandblock statements first}] label: 'example'.
	^ aBlock containingArtefact isMethod and: [aBlock containingArtefact arguments contains: [:arg | arg contents = 'aCanvas']]
]

{ #category : #'as yet unclassified' }
SBStCanvasPalette class >> title [

	^ 'Canvas'
]
