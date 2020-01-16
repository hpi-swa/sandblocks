as yet unclassified
layout: aMorph in: aRectangle

	| receiver signature receiverExtent signatureBounds |
	receiver := aMorph receiver ifNil: [
		SBKeywordMessageLayout layout: aMorph signature in: aRectangle.
		aMorph signature layoutInBounds: aRectangle positioning: #topLeft.
		^ self].
	signature := aMorph signature.
	receiverExtent := receiver minExtent.
	
	" place in single row "
	(self wantsSingleRow: receiver signature: signature) ifTrue: [ |  signatureExtent |
		signatureExtent := SBHorizontalLayout minExtentOf: signature in: aRectangle.
		receiver layoutInBounds: (aRectangle origin + (0 @ (aRectangle height - receiverExtent y // 2)) extent: receiverExtent).
		signatureBounds := aRectangle origin + (receiverExtent x + aMorph cellGap @ (aRectangle height - signatureExtent y // 2)) extent: signatureExtent.
		SBHorizontalLayout layout: signature in: signatureBounds.
		signature layoutInBounds: signatureBounds positioning: #topLeft.
		^ self].
	
	" place receiver and message part in first row, argument in second "
	(self wantsReceiverAndMessageRow: aMorph) ifTrue: [ | messageExtent argumentExtent firstHeight message argument |
		message := signature firstSubmorph.
		argument := signature lastSubmorph.
		messageExtent := message minExtent.
		argumentExtent := argument minExtent.
		firstHeight := receiverExtent y max: messageExtent y.
		receiver layoutInBounds: (aRectangle origin + (0 @ (firstHeight - receiverExtent y // 2)) extent: receiverExtent) positioning: #topLeft.
		message layoutInBounds: (aRectangle origin + (receiverExtent x + aMorph cellGap @ (firstHeight - messageExtent y // 2)) extent: messageExtent) positioning: #topLeft.
		argument layoutInBounds: (aRectangle origin + (self indent @ (aMorph cellGap + (receiverExtent y max: messageExtent y))) extent: argumentExtent) positioning: #topLeft.
		signature layoutInBounds: (aRectangle origin + (self indent @ (firstHeight - messageExtent y // 2)) extent: 0 @ 0) positioning: #topLeft.
		^ self].
	
	receiver layoutInBounds: (aRectangle origin extent: receiverExtent).
	signatureBounds := aRectangle origin + (self indent @ (receiverExtent y + aMorph cellGap)) extent: (SBKeywordMessageLayout minExtentOf: signature in: aRectangle).
	SBKeywordMessageLayout layout: signature in: signatureBounds.
	signature layoutInBounds: signatureBounds positioning: #topLeft