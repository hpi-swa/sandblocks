as yet unclassified
workspace
	"self workspace"

"Clipboard clipboardText: (SBWorkspaceHistory default items detect: [:i | i name =  'tutorial'] ifFound: #workspaceString)"
	
	^  (SBEditor new
openMorph: (SBMethod newFor: SBTutorialSnippets >> #t09Assignments at: (2672@2643));
openMorph: (SBMethod newFor: SBTutorialSnippets >> #t07Smalltalk at: (2517@1856));
openMorph: (SBMethod newFor: SBTutorialSnippets >> #t08Lists at: (2685@2063));
openMorph: (SBMethod newFor: SBTutorialSnippets >> #t05BasicMessageSend at: (1937@1559));
openMorph: (SBMethod newFor: SBTutorialSnippets >> #t06EditingValues at: (2010@1835));
openMorph: (SBRepl newFromSource: '[
	''Hi there! Welcome to the tutorial.
Use Cmd+hjkl to jump between steps/methods.

To ensure your selection is visible, press !'']' named: 'Welcome to the tutorial' at: (100@100));
openMorph: (SBMethod newFor: SBTutorialSnippets >> #t03Swapping at: (772@1277));
openMorph: (SBMethod newFor: SBTutorialSnippets >> #t02deleting at: (535@978));
openMorph: (SBMethod newFor: SBTutorialSnippets >> #t01movement at: (528@570));
openMorph: (SBMethod newFor: SBTutorialSnippets >> #t04Jumping at: (1224@1408));
yourself) openInWindow