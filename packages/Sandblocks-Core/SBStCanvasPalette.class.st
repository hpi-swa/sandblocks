Class {
	#name : #SBStCanvasPalette,
	#superclass : #SBPalette,
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBStCanvasPalette >> grammarHandler [

	^ SBSmalltalkGrammarHandler new
]

{ #category : #'as yet unclassified' }
SBStCanvasPalette >> initialize [

	super initialize.
	
	self
		addSectionHeader: 'Primitives';
		addBlock: 'Line' as: (SBMessageSend new receiver: (SBName contents: 'aCanvas') selector: #line:to:width:color: arguments: {self newNullBlock: 'from'. self newNullBlock: 'to'. self newNullBlock: 'width'. SBColor new colorContents: Color red});
		addBlock: 'Fill Rectangle' as: (SBMessageSend new receiver: (SBName contents: 'aCanvas') selector: #fillRectangle:color: arguments: {self newNullBlock: 'rect'. SBColor new colorContents: Color red});
		addBlock: 'Frame Rectangle' as: (SBMessageSend new receiver: (SBName contents: 'aCanvas') selector: #frameRectangle:width:color: arguments: {self newNullBlock: 'rect'. self newNullBlock: 'width'. SBColor new colorContents: Color red});
		addBlock: 'Fill Oval' as: (SBMessageSend new receiver: (SBName contents: 'aCanvas') selector: #fillOval:color: arguments: {self newNullBlock: 'rect'. SBColor new colorContents: Color red});
		addBlock: 'Frame Oval' as: (SBMessageSend new receiver: (SBName contents: 'aCanvas') selector: #frameOval:width:color: arguments: {self newNullBlock: 'rect'. self newNullBlock: 'width'. SBColor new colorContents: Color red});
		
		addSectionHeader: 'Transforms';
		addBlock: 'Translate' as: (SBMessageSend new receiver: (SBName contents: 'aCanvas') selector: #translateBy:during: arguments: {self newNullBlock: 'offset'. SBBlockBody emptyWithDeclarations: {'canvas'}})
]
