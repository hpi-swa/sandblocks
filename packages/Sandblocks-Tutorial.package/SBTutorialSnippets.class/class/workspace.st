as yet unclassified
workspace
	"self workspace"

"Clipboard clipboardText: (SBWorkspaceHistory default items detect: [:i | i name =  'tutorial'] ifFound: #workspaceString)"
	
	^ (SBEditor new
openMorph: (SBMethod newFor: SBTutorialSnippets >> #t13Evaluating at: (3047@3032));
openMorph: (SBMethod newFor: SBTutorialSnippets >> #t11Cascades at: (2776@2655));
openMorph: (SBMethod newFor: SBTutorialSnippets >> #t10Assignments at: (2722@2394));
openMorph: (SBMethod newFor: SBTutorialSnippets >> #t07Smalltalk at: (2517@1655));
openMorph: (SBMethod newFor: SBTutorialSnippets >> #t08Lists at: (2685@1815));
openMorph: (SBMethod newFor: SBTutorialSnippets >> #t05BasicMessageSend at: (1937@1559));
openMorph: (SBMethod newFor: SBTutorialSnippets >> #t06EditingValues at: (2010@1835));
openMorph: (SBRepl newFromSource: '[
	''Hi there! Welcome to the tutorial.
Use Cmd+hjkl to jump between steps/methods.

To ensure your selection is visible, press !

You can move the viewport either with horizontal scroll
or with the right mouse button.'']' named: 'Welcome to the tutorial!' at: (84@188));
openMorph: (SBMethod newFor: SBTutorialSnippets >> #t03Swapping at: (772@1277));
openMorph: (SBMethod newFor: SBTutorialSnippets >> #t02deleting at: (535@978));
openMorph: (SBMethod newFor: SBTutorialSnippets >> #t01movement at: (241@479));
openMorph: (SBMethod newFor: SBTutorialSnippets >> #t04Jumping at: (1224@1408));
openMorph: (SBMethod newFor: SBTutorialSnippets >> #t09MessageSends at: (2658@2023));
openMorph: (SBMethod newFor: SBTutorialSnippets >> #t12Projections at: (2791@2886));yourself) openInWindow