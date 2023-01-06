//
//  Persistence.swift
//  Ratiba
//
//  Created by ian robert blair on 2023/1/6.
//

import Foundation
import CoreData

class CoreDataManager {
    let persistentContainer: NSPersistentContainer
    
    init() {
        persistentContainer = NSPersistentContainer(name: "Ratiba")
        persistentContainer.loadPersistentStores { desciption, error in
            if let error = error {
                fatalError("Core Data failed to initialize \(error.localizedDescription)")
            }
        }
    }
    
    func saveClass(name: String, notes: String, desc: String, type: String, location: String, start: Date, length: Int16 = 0) {
        let ratibaClass = RatibaClass(context: persistentContainer.viewContext)
        
        ratibaClass.id = UUID()
        ratibaClass.name = name
        ratibaClass.notes = notes
        ratibaClass.desc = desc
        ratibaClass.type = type
        ratibaClass.location = location
        ratibaClass.start = start
        ratibaClass.length = Int16(length)
        
        do {
            try persistentContainer.viewContext.save()
            print("Application saved...")
        } catch {
            print("Failed to save application: \(error.localizedDescription)")
        }
        
    }
    
    func saveStudent(name: String, email: String, age: Int16 = 0, occupation: String, phone: String, socialMedia: String, level: String, certifications: String, wants: String, needs: String, gaps: String, studyHistory: String, pic: UUID) {
        
        let student = Student(context: persistentContainer.viewContext)
        
        student.name = name
        student.email = email
        student.age = Int16(age)
        student.occupation = occupation
        student.phone = phone
        student.socialMedia = socialMedia
        student.level = level
        student.certifications = certifications
        student.wants = wants
        student.needs = needs
        student.studyHistory = studyHistory
        student.pic = pic.uuidString
        
        do {
            try persistentContainer.viewContext.save()
            print("Application saved...")
        } catch {
            print("Failed to save application: \(error.localizedDescription)")
        }
        
    }
    
    func getStudents() -> [Student] {
        
        let fetchRequest: NSFetchRequest<Student> = Student.fetchRequest()
        
        do {
            return try persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            return []
        }
    }
    
    func deleteStudent(student: Student) {
        
        persistentContainer.viewContext.delete(student)
        
        do {
            try persistentContainer.viewContext.save()
        } catch {
            persistentContainer.viewContext.rollback()
            print("Failed to save context \(error.localizedDescription)")
        }
    }
    
    func deleteClass(ratibaClass: RatibaClass) {
        
        persistentContainer.viewContext.delete(ratibaClass)
        
        do {
            try persistentContainer.viewContext.save()
        } catch {
            persistentContainer.viewContext.rollback()
            print("Failed to save context \(error.localizedDescription)")
        }
    }
    
    private func classesByDate(date:Date) -> [RatibaClass]? {
        let startOfDay = date.startOfDay as NSDate
        let endOfDay = date.endOfDay as NSDate
        let context = persistentContainer.viewContext
        let fetch: NSFetchRequest<RatibaClass> = RatibaClass.fetchRequest()
        fetch.predicate = NSPredicate(format: "start >= %@ AND start <= %@", startOfDay, endOfDay)
        
        do {
            let results = try context.fetch(fetch)
            return (results)
        } catch  {
            print("Fetch classes error: ", error)
            return nil
        }
    }
    
    func weeksClasses(date:Date) -> [Day] {
        var count = 0
        var allDays = [Day]()
        let datesOfTheWeek = weekContainingDate(date: date)
        
        for eachDate in datesOfTheWeek  {
            var hasClasses:Bool = false
            let classesOnDay = classesByDate(date: eachDate)
            if let classesOnDay = classesOnDay {
                if classesOnDay.count > 0 {
                    hasClasses = true
                }
            }
            allDays.append(Day(id: count, date:eachDate, ratibaClasses: classesOnDay, hasClasses:hasClasses))
            count += 1
        }
        
        return allDays
    }

    private func weekContainingDate(date: Date) -> [Date] {
        let startDate = date
        var startOfWeek = Date()
        let calendar = Calendar.current
        let dayInSeconds:Int = 60 * 60 * 24
        var dates = [Date]()
        let component: DateComponents = calendar.dateComponents([.day, .weekday], from: date)
        
        startOfWeek = startDate.addingTimeInterval(-Double(dayInSeconds * component.weekday!))
        
        for day in (1...7) {
            var nextDay = Date()
            let nextInterval:Double = Double(dayInSeconds * day)
            nextDay = startOfWeek.addingTimeInterval(nextInterval)
            dates.append(nextDay)
        }
        
        return dates
    }
    
}

