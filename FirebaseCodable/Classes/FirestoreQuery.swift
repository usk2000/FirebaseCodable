//
//  FirestoreQuery.swift
//  FirebaseCodable
//
//  Created by hasegawa-yusuke on 2019/08/01.
//

import Foundation
import FirebaseFirestore

public extension Query {
    
    func getDocuments(_ completion: @escaping (Result<QuerySnapshot, FCError>) -> Void) {
        
        self.getDocuments { (snapshot, error) in
            
            if let error = error {
                completion(.failure(.firebaseError(error)))
                return
            }
            
            completion(.success(snapshot!))
            
        }
        
    }
    
    func getDocumentsAs<T>(_ type: T.Type, decoder: FCJSONDecoder, completion: @escaping (Result<[T], FCError>) -> Void) where T: FirebaseCodable {
        
        self.getDocuments { snapshot, error in
            
            if let error = error as NSError? {
                completion(.failure(.firebaseError(error)))
                return
            }
            
            let result = snapshot!.documents.compactMap({ child -> T? in
                do {
                    return try decoder.decode(type, json: child.data(), id: child.documentID)
                } catch let error {
                    debugPrint(error)
                    return nil
                }
            })

            completion(.success(result))
            
        }
        
    }
    
    func getDocumentsResponse<T>(_ type: T.Type, decoder: FCJSONDecoder, completion: @escaping (Result<DocumentResponse<T>, FCError>) -> Void) where T: FirebaseCodable {
        
        self.getDocuments { snapshot, error in
            
            if let error = error as NSError? {
                completion(.failure(.firebaseError(error)))
                return
            }
            
            let result = snapshot!.documents.compactMap({ child -> T? in
                do {
                    return try decoder.decode(type, json: child.data(), id: child.documentID)
                } catch let error {
                    debugPrint(error)
                    return nil
                }
            })
            
            let response = DocumentResponse<T>.init(items: result, lastSnapshot: snapshot!.documents.last)
            completion(.success(response))
            
        }
        
    }
    
    @discardableResult
    func addSnapshotListenerAs<T: FirebaseCodable>(_ type: T.Type, decoder: FCJSONDecoder, completion: @escaping (Result<FCSnapshotDiff<T>, FCError>) -> Void) -> ListenerRegistration {
        
        return addSnapshotListener({ snapshot, error in
            if let error = error {
                completion(.failure(.firebaseError(error)))
            } else {
                
                guard let snapshot = snapshot else { return }
                
                let added = snapshot.documentChanges.filter({ $0.type == .added }).compactMap({ change -> T? in
                    do {
                        return try decoder.decode(type, json: change.document.data(), id: change.document.documentID)
                    } catch let error {
                        debugPrint(error)
                        return nil
                    }
                })
                let modified = snapshot.documentChanges.filter({ $0.type == .modified }).compactMap({ change -> T? in
                    do {
                        return try decoder.decode(type, json: change.document.data(), id: change.document.documentID)
                    } catch let error {
                        debugPrint(error)
                        return nil
                    }
                })
                let removed = snapshot.documentChanges.filter({ $0.type == .removed }).compactMap({ change -> T? in
                    do {
                        return try decoder.decode(type, json: change.document.data(), id: change.document.documentID)
                    } catch let error {
                        debugPrint(error)
                        return nil
                    }
                })
                
                var diffs: [SnapshotDiff<T>] = []
                if !removed.isEmpty { diffs.append(.removed(removed))}
                if !modified.isEmpty { diffs.append(.modified(modified))}
                if !added.isEmpty { diffs.append(.added(added)) }
                
                completion(.success(FCSnapshotDiff<T>(diffs: diffs)))
                
            }
        })
        
    }

}
