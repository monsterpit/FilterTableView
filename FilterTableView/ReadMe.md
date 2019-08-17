View is basically just only  doing the work of displaying the data or doing an action

All of the logic is being delegated to the viewmodel 
Viewmodel which will call service managers

//remote amend 
// https://stackoverflow.com/questions/253055/how-do-i-push-amended-commit-to-the-remote-git-repository


//Basic MVVM Pattern


View ,ViewController 

Delegate-> onAdd,OnRemove,OnDone
view things that happens are put into “protocol” e.g. in viewController there was adding  and removing





ViewModel

VCViewModel   (Requires weak View Delegate) , (State maintaining variable Delegate)
Delegate ->  onAdd,onRemove,OnItemDone


Cell    (Requires weak VCViewModel)   (Delegate of state like id ,textValue displays)
Delegate -> onItemSelected,onDone,onRemove

CellMenuItem (Requires weak Cell Delegate) , (Delegate of state like title , backgroundColor)
Delegate -> onItemSelected
