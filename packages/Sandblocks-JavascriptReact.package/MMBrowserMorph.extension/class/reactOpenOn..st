*Sandblocks-JavascriptReact
reactOpenOn: aUrl

	^ self new
		viewportSize: 300 @ 300;
		performedAutoResizing: false;
		connect: aUrl;
		changed;
		yourself