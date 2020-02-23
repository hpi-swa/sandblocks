as yet unclassified
paragraph

	^ "paragraph ifNil: "true ifTrue: [
		paragraph := NewParagraph new
			compose: self contents asText
			style: TextStyle default
			from: 1
			in: (self position extent: 9999 @ 9999);
			adjustRightX;
			focused: true;
			showCaret: self cursor > 0;
			caretColor: Color red.
		
		paragraph
			selectionStart: (paragraph characterBlockForIndex: self cursor)
			selectionStop: (paragraph characterBlockForIndex: self cursor)]