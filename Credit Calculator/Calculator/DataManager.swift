import Foundation
import CoreData

// Entity: CreditRecord
//@objc(CreditRecord)
//public class CreditRecord: NSManagedObject {
//    @NSManaged public var credit: Double
//    @NSManaged public var stavka: Double
//    @NSManaged public var durationInDays: Int32
//    @NSManaged public var overpayment: Double
//    @NSManaged public var monthlyPayment: Double
//}

//extension CreditRecord {
//    @nonobjc public class func fetchRequest() -> NSFetchRequest<CreditRecord> {
//        return NSFetchRequest<CreditRecord>(entityName: "CreditRecord")
//    }
//}

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "CreditModel")
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
}
