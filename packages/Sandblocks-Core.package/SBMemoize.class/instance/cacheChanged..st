as yet unclassified
cacheChanged: aNumber

	aNumber = self identifier ifTrue: [
		self class cache
			at: self identifier
			ifPresent: [:object |
				self lastSubmorph lastSubmorph
					addMorphBack: (SBIcon iconSearch
						on: #click send: #exploreCached to: self;
						balloonText: 'Explore cached value';
						yourself);
					addMorphBack: (SBStringMorph new
						contents: (object printStringLimitedTo: 20);
						yourself)]]