as yet unclassified
paragraph

	^ paragraph ifNil: [ | cursors |
		paragraph := NewParagraph new
			compose: self contents asText
				style: TextStyle default
				from: 1
				in: (self position extent: (maxWidth ifNil: [9999]) @ 9999);
			adjustRightX;
			focused: true;
			showCaret: self cursor > 0;
			caretColor: Color red.
		
		cursors := self selectionBounds.
		paragraph
			selectionStart: (paragraph characterBlockForIndex: cursors first)
			selectionStop: (paragraph characterBlockForIndex: cursors second)]