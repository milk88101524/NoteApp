//
//  CoreDataConnect.swift
//  TodoList
//
//  Created by Han on 2024/10/8.
//

import CoreData
import Foundation

class CoreDataConnect {
    var context: NSManagedObjectContext! = nil
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
/* ========================================== TODO ========================================== */
    
    // MARK: Todo create
    func createTodo(title: String) -> Bool {
        let insetData = NSEntityDescription.insertNewObject(forEntityName: "Todo", into: context)
        
        insetData.setValue(UUID().uuidString, forKey: "id")
        insetData.setValue(title, forKey: "title")
        insetData.setValue(false, forKey: "isCompleted")
        
        do {
            try context.save()
            
            return true
        } catch {
            print(error)
            return false
        }
    }
    
    // MARK: Todo read
    func loadTodo() -> [TodoModel] {
        let request = NSFetchRequest<NSManagedObject>(entityName: "Todo")
        
        do {
            let result = try context.fetch(request)
            
            // 將 NSManagedObject 轉換為 TodoModel
            let todoList: [TodoModel] = result.compactMap { obj in
                // 確認從 NSManagedObject 中可以取出這些屬性
                guard let id = obj.value(forKey: "id") as? String,
                      let title = obj.value(forKey: "title") as? String,
                      let isCompleted = obj.value(forKey: "isCompleted") as? Bool else {
                    return nil
                }
                
                // 創建對應的 TodoModel
                // 把轉型後的 TodoMadel 再丟回 todoList
                return TodoModel(id: id, title: title, isCompleted: isCompleted)
            }
            
            return todoList
            
        } catch {
            print(error)
            return []
        }
    }
    
    
    // MARK: Todo update
    func updateTodo(id: String, isCompleted: Bool) -> Bool {
        let request = NSFetchRequest<NSManagedObject>(entityName: "Todo")
        request.predicate = NSPredicate(format: "id == %@", id)
        
        do {
            let result = try context.fetch(request)
            
            if let todoUpdate = result.first {
                todoUpdate.setValue(isCompleted, forKey: "isCompleted")
                
                try context.save()
                
                return true
            } else {
                print("Todo not found")
                return false
            }
        } catch {
            print(error)
            return false
        }
    }
    
    // MARK: Todo delete
    func deleteTodo(id: String) -> Bool {
        let request = NSFetchRequest<NSManagedObject>(entityName: "Todo")
        request.predicate = NSPredicate(format: "id == %@", id)
        
        do {
            let result = try context.fetch(request)
            
            if let todoDelete = result.first {
                context.delete(todoDelete)
                
                try context.save()
                
                return true
            } else {
                print("Todo not found")
                return false
            }
        } catch {
            print(error)
            return false
        }
    }
    
/* ========================================== NOTE ========================================== */
    
    // MARK: Note create
    func createNote(title: String, content: String) -> Bool {
        let insetData = NSEntityDescription.insertNewObject(forEntityName: "Note", into: context)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateTime = dateFormatter.string(from: Date())
        
        insetData.setValue(UUID().uuidString, forKey: "id")
        insetData.setValue(title, forKey: "title")
        insetData.setValue(content, forKey: "content")
        insetData.setValue(dateTime, forKey: "dateTime")
        
        do {
            try context.save()
            
            return true
        } catch {
            print(error)
            return false
        }
    }
    
    // MARK: Note read
    func loadNote() -> [NoteModel] {
        let request = NSFetchRequest<NSManagedObject>(entityName: "Note")
        
        do {
            let result = try context.fetch(request)
            
            // 將 NSManagedObject 轉換為 TodoModel
            let noteList: [NoteModel] = result.compactMap { obj in
                // 確認從 NSManagedObject 中可以取出這些屬性
                guard let id = obj.value(forKey: "id") as? String,
                      let title = obj.value(forKey: "title") as? String,
                      let content = obj.value(forKey: "content") as? String,
                      let dateTime = obj.value(forKey: "dateTime") as? String
                else {
                    return nil
                }
                
                // 創建對應的 TodoModel
                // 把轉型後的 TodoMadel 再丟回 todoList
                return NoteModel(id: id, title: title, content: content, dateTime: dateTime)
            }
            
            return noteList
            
        } catch {
            print(error)
            return []
        }
    }
    
    // MARK: Note update
    func updateNoteContent(id: String, content: String) -> Bool {
        let request = NSFetchRequest<NSManagedObject>(entityName: "Note")
        request.predicate = NSPredicate(format: "id == %@", id)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateTime = dateFormatter.string(from: Date())
        
        do {
            let result = try context.fetch(request)
            
            if let noteUpdate = result.first {
                noteUpdate.setValue(content, forKey: "content")
                noteUpdate.setValue(dateTime, forKey: "dateTime")
                
                try context.save()
                
                return true
            } else {
                print("Note not found")
                return false
            }
        } catch {
            print(error)
            return false
        }
    }
    
    // MARK: Note delete
    func deleteNote(id: String) -> Bool {
        let request = NSFetchRequest<NSManagedObject>(entityName: "Note")
        request.predicate = NSPredicate(format: "id == %@", id)
        
        do {
            let result = try context.fetch(request)
            
            if let noteDelete = result.first {
                context.delete(noteDelete)
                
                try context.save()
                
                return true
            } else {
                print("Note not found")
                return false
            }
        } catch {
            print(error)
            return false
        }
    }
}
