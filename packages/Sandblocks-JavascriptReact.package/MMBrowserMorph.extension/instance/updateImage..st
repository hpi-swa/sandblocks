*Sandblocks-JavascriptReact-override
updateImage: payload

	| form |
	form := self class parseImage: payload into: self image.
	form extent > viewportSize ifTrue: ["We need to crop the incoming image if we don't run Chrome in headless mode
		or if we just resized the window and Chrome still sends us a bigger image than now requested."
	form := form contentsOfArea: (0 @ 0 extent: viewportSize)].
	
	self image: form.
	self flag: #TODO.
	"The object does not understand checkResize. Only unless the React Tree Sitter projekt is loaded. Thus this might lead to errors and performedAutoResizing needs to be turned of all the time."
	self performedAutoResizing ifFalse: [
		self addAlarm: #checkResize after: 750.
		self performedAutoResizing: true]