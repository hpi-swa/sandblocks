private
distributeLeftOver: aNumber among: aCollection

	| spreading extraSpace |
	aNumber <= 0 ifTrue: [^ 0].
	
	spreading := (1 to: aCollection size) asOrderedCollection.
	extraSpace := aNumber.
	
	spreading sort: [ :index1 :index2 | | sizes1 sizes2 delta1 delta2 delta |
		sizes1 := aCollection at: index1.
		sizes2 := aCollection at: index2.
		delta1 := sizes1 naturalSize - sizes1 minSize.
		delta2 := sizes2 naturalSize - sizes2 minSize.
		delta := delta2 - delta1.
		delta == 0 ifTrue: [delta := index2 - index1].
		delta < 0 ].
	
	(1 to: aCollection size) reverseDo: [ :index | | item extra gap glue |
		extraSpace > 0 ifTrue: [
			item := aCollection at: (spreading at: index).
			glue := (extraSpace + index - 1 / index) floor.
			gap := item naturalSize - item minSize.
			extra := glue min: gap.
			item finalSize: item finalSize + extra.
			extraSpace := extraSpace - extra]].
	
	^ extraSpace