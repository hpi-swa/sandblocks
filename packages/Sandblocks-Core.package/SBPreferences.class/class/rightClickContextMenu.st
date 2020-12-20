accessing
rightClickContextMenu
	<preference: 'Right-click opens actions menu'
	category: 'sandblocks'
	description: 'Opens the actions menu on a right-clicked block. Disables right-click to move the canvas unless the canvas itself is clicked'
	type: #Boolean>
	^ RightClickContextMenu ifNil: [true]