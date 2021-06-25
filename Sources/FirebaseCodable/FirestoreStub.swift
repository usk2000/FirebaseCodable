//
//  File.swift
//  
//
//  Created by Yusuke Hasegawa on 2021/06/24.
//

import Foundation

#if !canImport(FirebaseFirestore)

#warning("You should install Firestore")

public class DocumentReference: NSObject {
    
    var path: String { return "" }

    func getDocument(completion: @escaping DocumentSnapshotBlock) {
        
    }
    
    func setData(_ documentData: [String: Any], completion: ((Error?) -> Void)? = nil) {
        
    }
    
    func updateData(_ fields: [AnyHashable : Any], completion: ((Error?) -> Void)? = nil) {

    }
    
    func addSnapshotListener(_ listener: @escaping DocumentSnapshotBlock) -> ListenerRegistration {
        return ListenerRegistration()
    }
    
    func delete(completion: ((Error?) -> Void)? = nil) { }
}

public class Query: NSObject {
    
    func getDocuments(source: FirestoreSource, completion: @escaping QuerySnapshotBlock) {
        
    }
    
    func addSnapshotListener(_ listener: @escaping QuerySnapshotBlock) -> ListenerRegistration {
        return ListenerRegistration()
    }
    
}

public class DocumentSnapshot: NSObject {
    var exits: Bool { return true }
    var documentID: String { return "" }
    func data() -> [String : Any]? { return [:] }
    open var reference: DocumentReference { return DocumentReference() }
}

public class QuerySnapshot: NSObject {
    var documents: [QueryDocumentSnapshot] { return [] }
    var documentChanges: [DocumentChange] { return [] }
}

public class QueryDocumentSnapshot: DocumentSnapshot {
    override func data() -> [String: Any] { return [:] }
}

public class ListenerRegistration: NSObject {
    
}

public enum FirestoreSource : UInt {
    case `default` = 0
}

public class DocumentChange: NSObject {
    var type: DocumentChangeType { return .added }
    var document: QueryDocumentSnapshot { return QueryDocumentSnapshot() }
}

public enum DocumentChangeType {
    case added
    case modified
    case removed
}


public typealias QuerySnapshotBlock = (QuerySnapshot?, Error?) -> Void
public typealias DocumentSnapshotBlock = (DocumentSnapshot?, Error?) -> Void

struct Timestamp {
    var seconds: Int
    var nanoseconds: Int
}

#endif
