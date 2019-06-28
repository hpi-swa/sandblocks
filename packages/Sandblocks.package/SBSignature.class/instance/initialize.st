as yet unclassified
initialize

	super initialize.
	
	self changeTableLayout.
	"self layoutPolicy: SBMessageLayout new."
	self vResizing: #shrinkWrap.
	self hResizing: #shrinkWrap.
	self listDirection: #leftToRight