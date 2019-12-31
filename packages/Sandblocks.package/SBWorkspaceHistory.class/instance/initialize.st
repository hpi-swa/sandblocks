as yet unclassified
initialize

	super initialize.
	
	items := SortedCollection sortBlock: [:a :b | a date < b date]