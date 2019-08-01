//
//  FirestoreDocument.swift
//  FirebaseCodable
//
//  Created by hasegawa-yusuke on 2019/08/01.
//

import Foundation
import FirebaseFirestore

extension DocumentReference {
    
    func getDocument(completion: @escaping (Result<DocumentSnapshot, FCError>) -> Void) {
        
        self.getDocument { (snapshot, error) in
            
            if let error = error {
                completion(.failure(.firebaseError(error)))
                return
            }
            
            completion(.success(snapshot!))

        }
        
    }
    
    func getDocumentAs<T>(_ type: T.Type, decoder: FCJSONDecoder, completion: @escaping (Result<T?, FCError>) -> Void) where T: FirebaseCodable {
        
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
    
    func setDataAs<T>(_ data: T, encoder: FCJSONEncoder, completion: @escaping (Result<Void, FCError>) -> Void) where T: FirebaseCodable {
        
        do {
            let json = try encoder.encodeToJson(data)
            setData(documentData: json, completion: completion)
        } catch let error {
            completion(.failure(.systemError(error)))
        }
        
    }
    
    func setData(documentData: [String: Any], completion: @escaping (Result<Void, FCError>) -> Void) {
        
        self.setData(documentData) { error in
           
            if let error = error {
                completion(.failure(.firebaseError(error)))
                return
            }
            
            completion(.success(()))
            
        }
        
    }
    
    //パラメータを指定してアップデート
    func updateData(fields: [String: Any], completion: @escaping (Result<Void, FCError>) -> Void) {
        
        self.updateData(fields) { (error) in
            
            if let error = error {
                completion(.failure(.firebaseError(error)))
                return
            }
            
            completion(.success(()))
            
        }
        
    }
    
    @discardableResult
    func addSnapshotListenerAs<T: FirebaseCodable>(_ type: T.Type, decoder: FCJSONDecoder, completion: @escaping (Result<T?, FCError>) -> Void) -> ListenerRegistration {
        
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