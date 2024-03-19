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
        try! realm.commitWrite()
    }
    
    func deleteObjectFromRealm(url: String) {
        guard let realm = createRealmInstance() else { return }
        
        realm.beginWrite()
        realm.delete(realm.objects(FeedObject.self).where { $0.feedUrl == url }.first!)
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
        guard let realm = createRealmInstance() else { return }
        let targetFeedObject = realm.objects(FeedObject.self).where { $0.id == id }.first!
        
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


