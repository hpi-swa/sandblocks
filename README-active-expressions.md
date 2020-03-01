# Tool Support for Active Expressions in Babylonian Programming

Here, we describe a subsystem within our projectional editor dealing with active expressions [Ramson 2017].

![Screenshot of the subsystem](https://raw.githubusercontent.com/tom95/sandblocks/master/screenshots/active-expressions-figure.png)

## Summary
Babylonian Programming allows programmers to write code while being aware of the values flowing through the program. This reduces the burden on programmers to imagine program execution in their head. However, we identified three problems when looking at Babylonian Programming in combination with code that uses active expressions.
1. The control flow no longer synchronously follows our written program. Instead, the control flow may jump from remote modules to our active expression and trigger side effects of equally unknown scope.
2. Further, using active expressions for GUI programming simplifies expressing constraints and maintaining consistency throughout the interface state. However, Babylonian Programming is scoped to one single method and its synchronous execution, while GUI programs typically act event-based.
3. Lastly, especially when considering GUI components and not just individual methods, we may often deal with a large number of active expressions, which combined make up the behavior we need to observe.

Our approach to each problem is as follows:
1. To help understanding the control flow, for each activation of an active expression, we allow to show the callstack leading up to the activation and each callstack of the sideeffects that the active expression triggered.
2. To help understanding event-based GUI programs, we define a new type of long-running example that displays the program partially sandboxed and as such allows the programmer to interact with the program rather than just placing watches to observe otherwise offscreen behavior.
3. To deal with a large number of instances of an active expression, we display a color-coded marble diagram, allowing programmers to quickly see which instances triggered most often and in what order they have been triggered.

## Links / Demo
The sources can be found here: https://github.com/tom95/sandblocks

Installation instructions are here: https://github.com/tom95/sandblocks/blob/master/README.md

An example can be launched via `SBEditor openFor: {JumpingCubes. JCTile}`. Some manual layouting may be required to see all relevant elements. The shortcut "!" will focus the selected window should the editor come up seemingly empty.
By clicking on the refresh icon on the `JumpingCubes>>example`, the example will be executed, leading to an error.
By inspecting the watches on the active expressions in `JCTile>>findNeighbors`, the error can be located to be in `JCTile>>splitValue`, where the value assignment needs to happen before the neighbors get incremented. The order can be changed easily by clicking on the lower statement and pressing "K" to move it up.
Re-running the example should then result in the correct behavior and the red error bar from the failed assertion disappearing.

## Implementation Notes
The system makes heavy use of Smalltalk's `thisContext` feature to find depedencies and callstacks.

To derive sideeffects, we use Smalltalk's image-side interpreter to simulate the execution of the sideeffect handlers on the active expression.
For this purpose, we also provide a subclass of the `SynchronousActiveExpression` that invokes the sideeffect handlers via the simulator.
We distinguish between relevant and non-relevant sideeffects by tracking the identity of all objects that are created during the simulation.
These objects we consider as temporary objects.
When state is changed (meaning a variable changed was assigned a new value or a store into an object happened via `at:put:`), we see if this concerned one of the temporary objects.
If that is not the case, we consider the change as a relevant sideeffect (meaning persistent after execution of the sideeffect handler finished).

## Approach / Features
* Single Active Expression
  - Explore Dependencies ("anchor" icon)
  - Show subscribing blocks ("share" icon)
  - Explore "owner" of active expression, if any ("magnifying glass" icon)
  - List of all activations, their location in the code, their callstack when clicked, the value that the expression evaluated to, and all triggered, relevant (see below) sideeffects
* Multiple Active Expressions instantiated from one code location
  - Marble display for each invocation, color-coded by active expression instance
  - Sync Events: allows inserting synchronous "marbles" into the regular control flow (press "," on any node and select "wrap in marker")
  - Scrubbing through the list of all active expressions instantiated from this location (will automatically jump to an expression if it triggers a new activation)
  - Picking a morph and jumping to its active expressions, if any ("crosshair" icon)
  - On hovering a marble, highlight the owner object of the active expression if it is a morph and show the expression's value at that time
* Code Navigation
  - non-overlapping window layout
  - infite viewport, use touchpad scroll to move
  - "code accordion": visualization of stack
  - code opener: ctrl+x to open an overlay to select a method (is keyboard-centric, no support for mouse: use arrow keys to jump categories, ctrl+f to search for class name)
* Morph Examples
  - partially sandboxed morph display
  - catches initialization, test, and drawing errors and displays them on the relevant piece of code
  - supports restarting manually via "refresh" icon or on each method save (saving can be configured via "cmd+,", "Change compile method" to be on-change or on-save)
  - "test case" panel to specify instructions to be executed after the morph has been opened

## Assumptions / Limitations
* The most important limitation of this implementation is that it only displays the current state and does no further analysis of what may happen in the future (or happened in the past), as a static analysis might. This means that inspecting an active expression right after its creation may for example show that no one subscribes to it. Similarly, the dependencies of an active expression may change depending on the expression itself (`a ifTrue: [b] ifFalse: [c]`).
* The system assumes that there is only the single, sandboxed instance of the observed application, not more. Otherwise, events from both instances will currently be displayed.
* The system is not thread-safe, as it directly triggers updates to the tool UI.
* Color choices are computed using the identity hash of an instance, meaning that there may be duplicate colors or colors that are too similar to be told apart. A workaround to this problem would likely involve a global weak hashmap that rotates distinct colors for each new instance.
* There is only limited support for temporary and literal variables at the moment. Instance variables are fully supported. This is not a conceptual limitation, it would only require adapting/abstracting various places that assume direct ownership of a variable through an object and matching the other variable notify callbacks (`VarTra:notify:instVarNamed:ofObject:changedFrom:to:inContext:`).

## Discussion
The system uses a projectional editor to be able to have a deep, meaningful integration with the program's code. The projectional editor allowed us to quickly prototype various aspects of the system. All aspects should also be generalizable to text-based edtiors, but will require more effort to keep the UI consistent throughout partial or destructive edits of the code.

The system in its current state provides a good overview when there is only few instances of an active expression, or when there is many instances where the frequency and order of activations is of more importance than the values being passed. In contrast, if values of the different activations vary a lot across different instances, they may represent the more important metric. As we currently only display marbles for the activations and require the user to hover the marble to see the value that resulted from the expression's activation, it is a lot harder to for example recognize rising sequences of numbers across many instances of active expressions.
Addressing this issue would likely require an extensive use of space, as the string representations of values in the general case will not fit the small marbles we currently display. However, using this extensive space may break our current layout that is in-line with the code and require moving the active expression UI to a separate window, breaking the strong context we currently have.

Navigation in our tool is supported by a non-overlapping window system. Windows push each other apart until no more overlaps exist.
For some actions it is still desirable to provide more convenience during navigation: for example when opening a stack trace and traversing it to see if the information is relevant to the current task, users should have a quick way to "undo" this navigation and return to the previous context [Shneiderman 1996].
Further, windows currently push each other apart even when currently being dragged. This allows rearranging windows using a single grab action by using the grabbed window as a kind of "broom", however it also means that a grabbed window will break other windows' layout when traversing the same space, which is likely undesirable.
Navigation and layouting could be improved by incorporating more of the concepts described in the CodeBubbles paper [Bradgon 2010], for example groups and a minimap for the virtual workspace.

## Sources / Literature
This is most of the literature that influenced the design and implementation of our system.

* [Zhu, 2019], "How People Visually Represent Discrete Constraint Problems," IEEE Transactions on Visualization and Computer Graphics
* [Rauch, 2019] et al, "Babylonian-style Programming: Design and Implementation of an Integration of Live Examples into General-purpose Source Code", arXiv:1902.00549 [cs.SE]
* [Banken 2018] "Debugging Data Flows in Reactive Programs", ICSE 2018
* [Ko 2009] "Finding Causes of Program Output with the Java Whyline", CHI 2009
* [Bragdon 2010] "Code Bubbles: A Working Set-based Interface for Code Understanding and Maintenance", CHI 2010
* [Shneiderman 1996] "The eyes have it: a task by data type taxonomy for information visualizations", 1996 IEEE Symposium on Visual Languages
* [Ungar 1997] "Debugging and the Experience of Immediacy", Communications of the ACM 40
* [DeLine, 2010] "Software Development with Code Maps", Communications of the ACM Volume 53 Issue 8
* [LaToza, 2011]  "Visualizing Call Graphs", 2011 IEEE Symposium on Visual Languages and Human-Centric Computing
* [Krämer, 2012] "Blaze: Supporting Two-phased Call Graph Navigation in Source Code", CHI 2012
* [Edward 2004] "Example centric programming", OOPSLA '04
* [Ramson, 2017] "Active Expressions: Basic Building Blocks for Reactive Programming", The Art, Science, and Engineering of Programming, 2017, Vol. 1, Issue 2, Article 12

## Source Code
The relevant parts of the code are found in `packages/Sandblocks-ActiveExpressions.package`. In particular, the main UI element is the SBDisplayActiveExpression that is used inside a SBWatch whenever an active expression is observed.
All classes in the `Sandblocks-ActiveExpression` have class comments to further explain their intent.

In Sandblocks-Core, the classes relevant to code navigation are primarily the `SBMoveDecorator` and `SBCodeAccordion`. The `SBMorphExample` and `SBMorphExampleCase` are the projections supporting the morph examples.
