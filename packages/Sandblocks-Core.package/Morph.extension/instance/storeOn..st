*Sandblocks-Core
storeOn: aStream

	aStream nextPut: $(.
	aStream nextPutAll: self class name, ' basicNew'.
	
	1 to: self class instSize do: [:i |
		" ignore submorphs, owner and fullBounds "
		(i ~= 2 and: [i ~= 3 and: [i ~= 4]]) ifTrue: [
		aStream nextPutAll: ' instVarAt: ';
			store: i;
			nextPutAll: ' put: ';
			store: (self instVarAt: i);
			nextPut: $;]].
	
	aStream nextPutAll: ' instVarAt: 3 put: Array empty; '.
	self submorphsDo: [:morph |
		aStream nextPutAll: 'addMorphBack: '.
		morph storeOn: aStream.
		aStream nextPut: $;].
	
	aStream nextPutAll: ' yourself)'
