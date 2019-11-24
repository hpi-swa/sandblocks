as yet unclassified
applyMode: aSymbol

	scroll
		visible: aSymbol ~= #collapse;
		disableLayout: aSymbol = #collapse.
	
	aSymbol = #focus
		ifTrue: [ | focus |
			focus := self findMarkedBlock.
			scroll
				offset: 0 @ (focus top - self fadeSize max: 0);
				layoutPolicy: nil.
			self
				vResizing: #rigid;
				height: (focus height + (self fadeSize * 2) min: (scroll firstSubmorph height - scroll offset y)) + label height + (self layoutInset * 2);
				width: scroll firstSubmorph width + (self layoutInset * 2)]
		ifFalse: [
			self vResizing: #shrinkWrap.
			scroll
				offset: 0 @ 0;
				layoutPolicy: TableLayout new]