helper
applyMode: aSymbol

	mode  = aSymbol ifTrue: [^ self].
	mode := aSymbol.
	
	self method collapsed: aSymbol = #collapse.
	scroll hResizing: (aSymbol = #collapse ifTrue: [#shrinkWrap] ifFalse: [#spaceFill]).
	
	aSymbol = #focus
		ifTrue: [ | focus |
			focus := self findMarkedBlock.
			scroll
				offset: 0 @ (focus top - self fadeSize max: 0);
				layoutPolicy: nil.
			self
				vResizing: #rigid;
				height: (focus height + (self fadeSize * 2) min: (scroll firstSubmorph height - scroll offset y)) + (self layoutInset * 2);
				width: scroll firstSubmorph width + (self layoutInset * 2)]
		ifFalse: [
			self vResizing: #shrinkWrap.
			scroll
				offset: 0 @ 0;
				layoutPolicy: TableLayout new]