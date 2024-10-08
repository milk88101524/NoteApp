//
//  HomeViewController.swift
//  TodoList
//
//  Created by Han on 2024/10/1.
//

import UIKit

class TodoListViewController: UIViewController {
    var fab = FloatActionButton().floatingButton
    var todoListTableView = UITableView()
    
    // MARK: Set Core Data
    let moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var coreDataConnect: CoreDataConnect? = nil
    
    let table = "Todo"
    var todoList: [TodoModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        coreDataConnect = CoreDataConnect(context: moc)
        setupView()
        view.addSubview(fab)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        fab.frame = CGRect(
            x: Int(view.safeAreaLayoutGuide.layoutFrame.width) - 60 - 30,
            y: Int(view.safeAreaLayoutGuide.layoutFrame.height) - 30,
            width: 60,
            height: 60
        )
        fab.addTarget(self, action: #selector(fabOnClick), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadTodo()
    }
    
    @objc func fabOnClick() {
        let sheetVC = AddTaskViewController()
        
        sheetVC.addTask = { [self] task in
            if ((coreDataConnect?.createTodo(title: task)) != nil) {
                Toast.show(message: "Create Todo Success", in: self.view)
                print("Create Todo Success")
                loadTodo()
            } else {
                Toast.show(message: "Faile to Create Todo", in: self.view)
                print("Faile to Create Todo")
            }
        }
        
        if let sheet = sheetVC.sheetPresentationController {
            sheet.prefersGrabberVisible = true
            sheet.detents = [ .custom(resolver: { content in
                300
            }) ]
        }
        self.present(sheetVC, animated: true, completion: nil)
    }
    
    private func setupView() {
        view.backgroundColor = .white
        title = "Todo List"
        loadTodo()
        
        todoListTableView.translatesAutoresizingMaskIntoConstraints = false
        todoListTableView.register(TodoTableViewCell.self, forCellReuseIdentifier: "\(TodoTableViewCell.self)")
        todoListTableView.delegate = self
        todoListTableView.dataSource = self
        
        view.addSubview(todoListTableView)
        
        NSLayoutConstraint.activate([
            todoListTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            todoListTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            todoListTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            todoListTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    func loadTodo() {
        guard let todoList = coreDataConnect?.loadTodo() else { return }
        self.todoList = todoList
        print(todoList)
        self.todoListTableView.reloadData()
    }
}

// MARK: Data Source
extension TodoListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        todoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(TodoTableViewCell.self)", for: indexPath) as? TodoTableViewCell else { return UITableViewCell() }
        
        cell.title.text = todoList[indexPath.row].title
        cell.checkBox.isChecked = todoList[indexPath.row].isCompleted
        
        cell.toggle = { [self] isCompleted in
            todoList[indexPath.row].isCompleted = isCompleted
            if ((coreDataConnect?.updateTodo(id: todoList[indexPath.row].id, isCompleted: isCompleted)) != nil) {
                Toast.show(message: "Update Todo Success", in: self.view)
                print("Update Todo Success\(isCompleted)")
            } else {
                Toast.show(message: "Faile to Update Todo", in: self.view)
                print("Faile to Update Todo\(isCompleted)")
            }
            loadTodo()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

// MARK: Delegate
extension TodoListViewController: UITableViewDelegate {
    // todo
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [self] _, _, completion in
            if ((coreDataConnect?.deleteTodo(id: todoList[indexPath.row].id)) != nil) {
                Toast.show(message: "Delete Todo Success", in: self.view)
                print("Delete Todo Success")
                loadTodo()
            } else {
                Toast.show(message: "Faile to Delete Todo", in: self.view)
                print("Faile to Delete Todo")
            }
            completion(true)
        }
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = .red
        
        let config = UISwipeActionsConfiguration(actions: [deleteAction])
        return config
    }
}

#Preview {
    UINavigationController(rootViewController: TodoListViewController())
}
