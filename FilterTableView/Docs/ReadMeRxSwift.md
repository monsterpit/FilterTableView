
Including RxSwift we will get RID of
DataSource of tableView


Rx has 4 types of Subjects types all of which can act as an observable and as an observer


1) Publish Subject
2) Behavior Subject
3) Replay Subject
4) Variable Subject


Subject(Simply means when a value is changed in that array you can subscribe to that change somewhere else so you get notification of those changes)


DisposeBag easily let's you handle memory management around Rx



Changes in RxSwift

//var items : [ItemPresentable]= []
var items : Variable<[ItemPresentable]> = Variable([])

//        items.append(contentsOf: [item1,item2,item3])
items.value.append(contentsOf: [item1,item2,item3])




//Binding tableView using ViewModel

viewModel?.items.asObservable().bind(to: tableView.rx.items(cellIdentifier: identifier, cellType: TableViewCell.self)){index,item,cell in
cell.configure(withItemViewModel: item)
}.disposed(by: disposeBag)





removes full UITableViewDataSource implementataions i.e.
cellForRowAt , NumberOfSections


we wont even require response callback from it i.e.
Protocols of Views like adding,reload,update,removing , in turn wont require to pass VC weak reference to ViewModel and could remove callbacks from ViewModel to ViewController
