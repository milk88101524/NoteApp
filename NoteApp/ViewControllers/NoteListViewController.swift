//
//  SecondViewController.swift
//  TodoList
//
//  Created by Han on 2024/10/4.
//

import UIKit

class NoteListViewController: UIViewController {
    // MARK: Set Core Data
    let moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var coreDataConnect: CoreDataConnect? = nil
    
    var fab = FloatActionButton().floatingButton
    var testCell = NoteTableViewCell()
    var noteTableView = UITableView()
    
    var noteList: [NoteModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        coreDataConnect = CoreDataConnect(context: moc)
        setupView()
        view.addSubview(fab)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        fab.frame = CGRect(
            x: Int(view.safeAreaLayoutGuide.layoutFrame.width) - 60 - 30,
            y: Int(view.frame.height) - 180,
            width: 60,
            height: 60
        )
        fab.addTarget(self, action: #selector(addNote), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadNote()
    }
    
    private func setupView() {
        navigationItem.title = "Note"
        navigationController?.navigationBar.prefersLargeTitles = true
        loadNote()
        
        noteTableView.register(NoteTableViewCell.self, forCellReuseIdentifier: "\(NoteTableViewCell.self)")
        noteTableView.separatorStyle = .none
        noteTableView.delegate = self
        noteTableView.dataSource = self
        noteTableView.allowsSelection = true
        noteTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(noteTableView)
        
        NSLayoutConstraint.activate([
            noteTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            noteTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            noteTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            noteTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    @objc func addNote() {
        navigationController?.pushViewController(AddNoteViewController(), animated: true)
    }
    
    func loadNote() {
        guard let noteList = coreDataConnect?.loadNote() else { return }
        self.noteList = noteList
        print(noteList)
        noteTableView.reloadData()
    }
}

extension NoteListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [self] _, _, completion in
            if ((coreDataConnect?.deleteNote(id: noteList[indexPath.row].id)) != nil) {
                print("Delete Note Success")
                loadNote()
            } else {
                print("Faile to Delete Note")
            }
            completion(true)
        }
        
        let config = UISwipeActionsConfiguration(actions: [deleteAction])
        return config
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let editNoteVC = EditNoteViewController()
        editNoteVC.note = noteList[indexPath.row]
        navigationController?.pushViewController(editNoteVC, animated: true)
    }
}

extension NoteListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        noteList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(NoteTableViewCell.self)", for: indexPath) as! NoteTableViewCell
        
        cell.titleLabel.text = noteList[indexPath.row].title
        cell.dateTitle.text = noteList[indexPath.row].dateTime
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

#Preview {
    UINavigationController(rootViewController: NoteListViewController())
}
