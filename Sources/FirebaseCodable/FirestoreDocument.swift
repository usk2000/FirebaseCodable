//
//  FirestoreDocument.swift
//  FirebaseCodable
//
//  Created by hasegawa-yusuke on 2019/08/01.
//

import Foundation
import FirebaseFirestore

public extension DocumentReference {
    
    /// get document
    ///
    /// - Parameter completion: result (success->DocumentSnapshot, fail->error)
    func getDocument(completion: @escaping (Result<DocumentSnapshot, FCError>) -> Void) {
        
        self.getDocument { (snapshot, error) in
            
            if let error = error {
                completion(.failure(.firebaseError(error)))
                return
            }
            
            completion(.success(snapshot!))

        }
        
    }
    
    /// get document and decode to object
    ///
    /// - Parameters:
    ///   - type: Class to decode
    ///   - decoder: decoder to use
    ///   - completion: result
    func getDocumentAs<T>(_ type: T.Type, decoder: FCJsonDecoderProtocol, completion: @escaping (Result<T?, FCError>) -> Void) where T: FirestoreCodable {
        
        self.getDocument { result in
           
            switch result {
            case .success(let snapshot):
                if snapshot.exists {
                    
                    do {
                        let data = snapshot.data()!
                        let value = try decoder.decode(type, json: data, id: snapshot.documentID)
                        completion(.success(value))
                    } catch let error {
                        completion(.failure(.systemError(error)))
                    }
                    
                } else {
                    completion(.success(nil))
                }
                
            case .failure(let error):
                completion(.failure(.firebaseError(error)))
            }
            
        }
    }
    
    /// set(save) data
    ///
    /// - Parameters:
    ///   - data: object to save
    ///   - encoder: encoder to use
    ///   - completion: result
    func setDataAs<T>(_ data: T, encoder: FCJsonEncoderProtocol, completion: @escaping (Result<Void, FCError>) -> Void) where T: FirestoreCodable {
        
        do {
            let json = try encoder.encodeToJson(data)
            setData(documentData: json, completion: completion)
        } catch let error {
            completion(.failure(.systemError(error)))
        }
        
    }
    
    /// set data
    ///
    /// - Parameters:
    ///   - documentData: map data
    ///   - completion: result
    func setData(documentData: [String: Any], completion: @escaping (Result<Void, FCError>) -> Void) {
        
        self.setData(documentData) { error in
           
            if let error = error {
                completion(.failure(.firebaseError(error)))
                return
            }
            
            completion(.success(()))
            
        }
        
    }
    

    /// update dta for specified fields
    ///
    /// - Parameters:
    ///   - fields: map of data
    ///   - completion: result
    func updateData(fields: [String: Any], completion: @escaping (Result<Void, FCError>) -> Void) {
        
        self.updateData(fields) { (error) in
            
            if let error = error {
                completion(.failure(.firebaseError(error)))
                return
            }
            
            completion(.success(()))
            
        }
        
    }
    
    /// observe update of document
    ///
    /// - Parameters:
    ///   - type: type of data
    ///   - decoder: decoder
    ///   - completion: result
    /// - Returns: observer object
    @discardableResult
    func addUpdateListenerAs<T: FirestoreCodable>(_ type: T.Type, decoder: FCJsonDecoderProtocol, completion: @escaping (Result<T?, FCError>) -> Void) -> ListenerRegistration {
        
        return self.addSnapshotListener { snapshot, error in
            
            if let error = error {
                completion(.failure(.firebaseError(error)))
            } else {
                let snapshot = snapshot!
                if snapshot.exists {
                    
                    do {
                        let data = snapshot.data()!
                        let value = try decoder.decode(type, json: data, id: snapshot.documentID)
                        completion(.success(value))
                    } catch let error {
                        completion(.failure(.systemError(error)))
                    }
                    
                } else {
                    completion(.success(nil))
                }
                
            }
            
        }
    }
    
    /// delete document
    ///
    /// - Parameter completion: result
    func deleteDocument(completion: @escaping ((Result<Void, FCError>) -> Void)) {
        
        delete { error in
            if let error = error {
                completion(Result.failure(.firebaseError(error)))
            } else {
                completion(Result.success(()))
            }
        }
        
    }
    
}
