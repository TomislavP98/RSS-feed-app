import RealmSwift

class RealmManager  {
    func createRealmInstance() -> Realm? {
        do {
            let realm = try Realm()
            return realm
        }
        catch {
            print("Realm instance fail!")
        }
        return nil
    }
    
    func addObjectToRealm(_ object: FeedObject) {
        guard let realm = createRealmInstance() else { return }
        
        realm.beginWrite()
        realm.add(object)
        
        do {
            try realm.commitWrite()
        }
        catch {
            print("Realm instance fail!")
        }
    }
    
    func deleteObjectFromRealm(url: String) {
        guard let realm = createRealmInstance() else { return }
        
        if let objectToDelete = realm.objects(FeedObject.self).where ({ $0.feedUrl == url }).first {
            realm.beginWrite()
            realm.delete(objectToDelete)
        }
        
        do {
            try realm.commitWrite()
        }
        catch {
            print("Realm instance fail!")
        }
    }
    
    func fetchAllFeeds() -> [FeedObject] {
        var objectArray: [FeedObject] = []
        guard let realm = createRealmInstance() else { return objectArray }
        
        objectArray = Array(realm.objects(FeedObject.self))
        objectArray.sort(by: { $0.feedName < $1.feedName })
        return objectArray
    }
    
    func fetchFavoriteFeeds() -> [FeedObject] {
        var objectArray: [FeedObject] = []
        guard let realm = createRealmInstance() else { return objectArray }
        
        objectArray = Array(realm.objects(FeedObject.self).where { $0.isFavorite })
        objectArray.sort(by: { $0.feedName < $1.feedName })
        return objectArray
    }
    
    func toggleFavorite(id: String) {
        guard let realm = createRealmInstance(), let targetFeedObject = realm.objects(FeedObject.self).where ({ $0.id == id }).first else { return }
        
        do {
            try realm.write {
                targetFeedObject.isFavorite.toggle()
            }
        }
        catch {
            print("Realm instance fail!")
        }
    }
}


