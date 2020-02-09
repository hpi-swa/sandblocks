as yet unclassified
initialize

	super initialize.
	value := 2.
	self
		 extent: self tileSize;
		 changeTableLayout;
		 cellPositioning: #center;
		 listCentering: #center;
		 wrapCentering: #center;
		 borderStyle: BorderStyle simple;
		 borderColor: Color black;
		 borderWidth: 1;
		 addMorphBack: (label := StringMorph new contents: value asString);
		 color: Color white