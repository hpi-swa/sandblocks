as yet unclassified
initialize

	super initialize.
	
	"self changeTableLayout."
	self layoutPolicy: SBKeywordMessageLayout new.
	self vResizing: #shrinkWrap.
	self hResizing: #shrinkWrap.
	self listDirection: #leftToRight.
	self cellInset: 2 * self scalingFactor.
	self color: Color transparent