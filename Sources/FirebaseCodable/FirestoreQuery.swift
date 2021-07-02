//
//  FirestoreQuery.swift
//  FirebaseCodable
//
//  Created by hasegawa-yusuke on 2019/08/01.
//

import Foundation
import FirebaseFirestore

public extension Query {
    
    /// get documents
    /// - Parameters:
    ///   - source: source
    ///   - completion: result
    func getDocuments(source: FirestoreSource, completion: @escaping (Result<QuerySnapshot, FCError>) -> Void) {
        
        self.getDocuments(source: source) { (snapshot, error) in
            
            if let error = error as NSError? {
                completion(.failure(.firebaseError(error)))
                return
            }
            
            completion(.success(snapshot!))
            
        }
        
    }
    
    /// get documents and decode
    /// - Parameters:
    ///   - type: type to decode
    ///   - source: source
    ///   - decoder: decoder
    ///   - completion: result
    func getDocumentsAs<T: FirestoreCodable>(_ type: T.Type, source: FirestoreSource, decoder: FCJsonDecoderProtocol, completion: @escaping (Result<[T], FCError>) -> Void) {
        
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
                    #if DEBUG
                    debugPrint(error)
                    #endif
                    return nil
                }
            })
            
            DispatchQueue.main.async {
                completion(.success(result))
            }
            
        }
        
    }
    
    /// get response of documents and decode
    /// - Parameters:
    ///   - type: type to decode
    ///   - source: source
    ///   - decoder: decoder
    ///   - completion: result
    func getDocumentResponseAs<T: FirestoreCodable>(_ type: T.Type, source: FirestoreSource, decoder: FCJsonDecoderProtocol, completion: @escaping (Result<FCDocumentResponse<T>, FCError>) -> Void) {
        
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
                    #if DEBUG
                    debugPrint(child.reference.path)
                    debugPrint(error)
                    #endif
                    return nil
                }
            })
            
            let response = FCDocumentResponse<T>.init(items: result, lastSnapshot: snapshot!.documents.last)
            DispatchQueue.main.async {
                completion(.success(response))
            }
            
        }
        
    }
    
    /// get documents synchronously
    /// - Parameters:
    ///   - type: type to decode
    ///   - source: source
    ///   - decoder: decoder
    /// - Throws: error
    /// - Returns: decoded objects
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
                        #if DEBUG
                        debugPrint(error)
                        #endif
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
    
    /// get documents asynchronously
    /// - Parameter source: source
    /// - Throws: error
    /// - Returns: snapshot
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
    
    /// observe update of documents
    /// 
    /// - Parameters:
    ///   - type: type to decode
    ///   - decoder: decoder
    ///   - completion: result
    /// - Returns: ListenerRegistration
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
                        #if DEBUG
                        debugPrint(error)
                        #endif
                        return nil
                    }
                })
                let modified = snapshot.documentChanges.filter({ $0.type == .modified }).compactMap({ change -> T? in
                    do {
                        return try decoder.decode(type, json: change.document.data(), id: change.document.documentID)
                    } catch let error {
                        #if DEBUG
                        debugPrint(error)
                        #endif
                        return nil
                    }
                })
                let removed = snapshot.documentChanges.filter({ $0.type == .removed }).compactMap({ change -> T? in
                    do {
                        return try decoder.decode(type, json: change.document.data(), id: change.document.documentID)
                    } catch let error {
                        #if DEBUG
                        debugPrint(error)
                        #endif
                        return nil
                    }
                })
                                
                completion(.success(FCSnapshotDiff<T>(added: added, modified: modified, removed: removed)))
            }
        })
        
    }

}
