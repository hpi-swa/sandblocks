as yet unclassified
initialize

	super initialize.
	self extent: 300 @ 300.
	self layoutInset: 6 withScalingFactor.
	self layoutPolicy: nil.
	self vResizing: #shrinkWrap.
	self hResizing: #shrinkWrap