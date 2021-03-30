Class {
	#name : #SBWelcome,
	#superclass : #SBBlock,
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBWelcome >> initialize [

	super initialize.
	
	self
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		layoutInset: 8;
		changeTableLayout;
		cellGap: 4;
		attachDecorator: SBMoveDecorator new;
		addMorphBack: (SBStringMorph new
			contents: 'Welcome to Sandblocks!';
			bold);
		addMorphBack: (SBStringMorph new contents: 'Click-and-drag the right mouse button to move the viewport.');
		addMorphBack: (Morph new
			height: 8;
			color: Color transparent);
		addMorphBack: (SBButton new
			icon: SBIcon iconRocket
			label: 'Open Tutorial'
			do: [SBTutorialStep resumeIn: self sandblockEditor]);
		addMorphBack: (SBButton new icon: SBIcon iconNewspaper_o label: 'Open Code Samples' do: [
			self sandblockEditor
				openMorphInView: SBScmModule example;
				openMorphInView: SBJsModule example;
				openMorphInView: (SBStPlayground example name: 'Smalltalk Workspace')]);
		addMorphBack: (SBButton new icon: SBIcon iconVine label: 'Use Vim-like Shortcuts' do: [
			self sandblockEditor useVimInput.
			SBEditor useInputMapping: SBVimInputMapping]);
		addMorphBack: (SBButton new icon: SBIcon iconCloud_download label: 'Update to bleeding-edge' do: [
			(Smalltalk at: #Metacello) new
				baseline: 'Sandblocks';
				repository: 'github://tom95/Sandblocks:master/packages';
				load: #tutorial])
]
