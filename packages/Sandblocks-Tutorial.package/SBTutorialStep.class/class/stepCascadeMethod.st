as yet unclassified
stepCascadeMethod

	| m |
	m := Morph new
		changeTableLayout;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap.
	m