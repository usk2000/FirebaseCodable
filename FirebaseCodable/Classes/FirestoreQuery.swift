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
    
    /// get documents and convert to specified type
    ///
    /// - Parameters:
    ///   - type: type to convert
    ///   - decoder: converter
    ///   - completion: result
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
    
    /// get documents, last snapshot and convert to specific type
    ///
    /// - Parameters:
    ///   - type: type to convert
    ///   - limit: limit of documents, if num of documents is equal to "limit", response has "lastSnapshot"
    ///   - decoder: decoder
    ///   - from: get data from this lastSnapshot
    ///   - completion: result
    func getDocumentsResponse<T>(_ type: T.Type,
                                 limit: Int,
                                 decoder: FCJSONDecoder,
                                 from: DocumentSnapshot? = nil,
                                 completion: @escaping (Result<FCDocumentResponse<T>, FCError>) -> Void) where T: FirebaseCodable {
        
        let query: Query
        if let from = from {
            query = self.start(afterDocument: from)
        } else {
            query = self
        }
        
        query.limit(to: limit).getDocuments { snapshot, error in
            
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
            
            let response: FCDocumentResponse<T>
            if snapshot!.documents.count == limit {
                response = FCDocumentResponse<T>(items: result, lastSnapshot: snapshot!.documents.last)
            } else { //no more data
                response = FCDocumentResponse<T>(items: result, lastSnapshot: nil)
            }
            completion(.success(response))
            
        }
        
    }
    
    /// observe update of objects
    ///
    /// - Parameters:
    ///   - type: type of object
    ///   - decoder: decoder
    ///   - completion: result
    /// - Returns: observer object
    @discardableResult
    func addUpdateListenerAs<T: FirebaseCodable>(_ type: T.Type, decoder: FCJSONDecoder, completion: @escaping (Result<FCSnapshotDiff<T>, FCError>) -> Void) -> ListenerRegistration {
        
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
