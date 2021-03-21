  FileStream startUp: true.
  TranscriptStream redirectToStdOut: true.
  Deprecation showDeprecationWarnings: false.

  Installer ensureRecentMetacello.

  (Smalltalk at: #MetacelloPlatform) current authorName: 'sbGenerated'.
  (Smalltalk at: #Metacello) new
    repository: 'github://squeak-smalltalk/squeak-tonel:squeak';
    baseline: 'Tonel';
    load.

  (Smalltalk at: #Metacello) new
  baseline: 'Sandblocks';
  repository: 'tonel:///home/runner/work/sandblocks/sandblocks/packages';
  load: #tutorial.

  "Prepare Image a little bit"
  Preferences disable: #showSharedFlaps.
  Preferences enable: #mouseOverForKeyboardFocus.
  HandMorph synthesizeMouseWheelEvents: false.
  PluggableSystemWindow allInstances do: #abandon.
  PreferenceWizardMorph allInstances do: #abandon.

  (Smalltalk at: #BaselineOfSandblocks) createSAR.

  (Smalltalk at: #SBEditor) openExample.
  SystemWindow topWindow expandToFullScreen.
  CodeHolder addSandblocks.

  "Wrap up the image and save it"
  TranscriptStream redirectToStdOut: false.
  Deprecation suppressed: false.

  SmalltalkImage current snapshot: true andQuit: true
