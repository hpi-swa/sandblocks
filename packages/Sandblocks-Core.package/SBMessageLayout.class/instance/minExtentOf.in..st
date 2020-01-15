as yet unclassified
minExtentOf: aMorph in: aRectangle

	| receiver signature receiverExtent signatureExtent |
	minExtentCache ifNotNil: [^ minExtentCache].
	
	receiver := aMorph receiver ifNil: [^ minExtentCache := SBKeywordMessageLayout minExtentOf: aMorph signature in: aRectangle].
	signature := aMorph signature.
	receiverExtent := receiver minExtent.
	
	" place in single row "
	(self wantsSingleRow: receiver signature: signature) ifTrue: [
		signatureExtent := SBHorizontalLayout new minExtentOf: signature in: aRectangle.
		^ minExtentCache := (receiverExtent x + aMorph cellGap + signatureExtent x) @ (receiverExtent y max: signatureExtent y)].
	
	" place receiver and message part in first row, argument in second "
	(self wantsReceiverAndMessageRow: aMorph) ifTrue: [ | messageExtent argumentExtent |
		messageExtent := signature firstSubmorph minExtent.
		argumentExtent := signature submorphs second minExtent.
		^ minExtentCache := (receiverExtent x + aMorph cellGap + messageExtent x max: self indent + argumentExtent x) @ ((receiverExtent y max: messageExtent y) + aMorph cellGap + argumentExtent y)].
	
	" place receiver in first row, message and argument pairs in subsequent "
	signatureExtent := SBKeywordMessageLayout minExtentOf: aMorph signature in: aRectangle.
	^ minExtentCache := (signatureExtent x + self indent max: receiverExtent x) @ (receiverExtent y + aMorph cellGap + signatureExtent y)