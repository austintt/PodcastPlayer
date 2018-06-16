/* Copyright 2018 Joseph Quigley
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

import Foundation
import RealmSwift

struct DatabaseController<RealmObject: Object> {
    var realmConfig: Realm.Configuration
    var ioQueue: DispatchQueue = DispatchQueue.global(qos: .background)
    
    private var shouldUpdate: Bool
    
    /// Creates a Realm-backed DatabaseController
    init(realmConfig: Realm.Configuration = Realm.Configuration.defaultConfiguration) {
        self.realmConfig = realmConfig
        // Tell Realm whether it should update the model on write (will only set this to yes if
        // your model has a primary key, otherwise an exception would be thrown).
        shouldUpdate = RealmObject.primaryKey()?.count ?? 0 > 0
    }
    
    
    /// Save model to the database
    ///
    /// - Parameters:
    ///   - model: Model to save
    ///   - completion: Completion handler with a boolean indicating success or not
    func save(_ model: RealmObject, completion: ((Bool)->())? = nil ) {
        let realmConfig = self.realmConfig
        let shouldUpdate = self.shouldUpdate
        ioQueue.async {
            let realm = try! Realm(configuration: realmConfig)
            
            let success: ()? = try? realm.write {
                // Create or update a record in this realm from an object in a different realm
                realm.create(RealmObject.self, value: model, update: shouldUpdate)
                debugPrint("Saved")
            }
            
            DispatchQueue.main.async {
                completion?(success != nil)
            }
        }
    }
    
    func query(predicate: NSPredicate? = nil) -> Results<RealmObject> {
        var results = try! Realm(configuration: realmConfig).objects(RealmObject.self)
        if let predicate = predicate {
            results = results.filter(predicate)
        }
        return results
    }
}
