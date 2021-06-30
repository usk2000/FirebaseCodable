//
//  FirestoreQuery.swift
//  FirebaseCodable
//
//  Created by hasegawa-yusuke on 2019/08/01.
//

import Foundation
import FirebaseFirestore

public extension Query {
    
    func getDocuments(source: FirestoreSource, completion: @escaping (Result<QuerySnapshot, FCError>) -> Void) {
        
        self.getDocuments(source: source) { (snapshot, error) in
            
            if let error = error as NSError? {
                completion(.failure(.firebaseError(error)))
                return
            }
            
            completion(.success(snapshot!))
            
        }
        
    }
        
    func getDocumentsAs<T>(_ type: T.Type, source: FirestoreSource, decoder: FCJsonDecoderProtocol, completion: @escaping (Result<[T], FCError>) -> Void) where T: FirestoreCodable {
        
        self.getDocuments(source: source) { (snapshot, error) in
            
            if let error = error as NSError? {
                DispatchQueue.main.async {
                    completion(.failure(.firebaseError(error)))
                }
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
            
            DispatchQueue.main.async {
                completion(.success(result))
            }
            
        }
        
    }
    
    func getDocumentResponseAs<T>(_ type: T.Type, source: FirestoreSource, decoder: FCJsonDecoderProtocol, completion: @escaping (Result<FCDocumentResponse<T>, FCError>) -> Void) where T: FirestoreCodable {
        
        self.getDocuments(source: source) { snapshot, error in
            
            if let error = error as NSError? {
                DispatchQueue.main.async {
                    completion(.failure(.firebaseError(error)))
                }
                return
            }
            
            let result = snapshot!.documents.compactMap({ child -> T? in
                do {
                    return try decoder.decode(type, json: child.data(), id: child.documentID)
                } catch let error {
                    debugPrint(child.reference.path)
                    debugPrint(error)
                    return nil
                }
            })
            
            let response = FCDocumentResponse<T>.init(items: result, lastSnapshot: snapshot!.documents.last)
            DispatchQueue.main.async {
                completion(.success(response))
            }
            
        }
        
    }
    
    func getDocumentsSync<T: FirestoreCodable>(_ type: T.Type, source: FirestoreSource, decoder: FCJsonDecoderProtocol) throws -> [T] {
        
        var documents: [T] = []
        var error: Error?
        let semaphore = DispatchSemaphore(value: 0)
        
        getDocuments(source: source) { result in
            defer { semaphore.signal() }
            switch result {
            case .success(let snapshot):
                documents = snapshot.documents.compactMap({ child -> T? in
                    do {
                        return try decoder.decode(type, json: child.data(), id: child.documentID)
                    } catch let error {
                        debugPrint(error)
                        return nil
                    }
                })
                
            case .failure(let err):
                error = err
            }
        }
        
        semaphore.wait()
        
        if let error = error {
            throw error
        }
        
        return documents
    }
    
    func getDocumentsSync(source: FirestoreSource) throws -> QuerySnapshot {
        var snapshot: QuerySnapshot?
        var error: Error?
        let semaphore = DispatchSemaphore(value: 0)

        getDocuments(source: source) { result in
            defer { semaphore.signal() }
            switch result {
            case .success(let snap):
                snapshot = snap
            case .failure(let err):
                error = err
            }
        }
        
        semaphore.wait()
        
        if let error = error {
            throw error
        }
        
        return snapshot!
    }
    
    @discardableResult
    func addSnapshotListenerAs<T: FirestoreCodable>(_ type: T.Type, decoder: FCJsonDecoderProtocol, completion: @escaping (Result<FCSnapshotDiff<T>, FCError>) -> Void) -> ListenerRegistration {
        
        return addSnapshotListener({ snapshot, error in
            if let error = error {
                completion(.failure(FCError.firebaseError(error)))
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
                                
                completion(.success(FCSnapshotDiff<T>(added: added, modified: modified, removed: removed)))
            }
        })
        
    }

}
