//
//  ViewController.swift
//  FirebaseCodable
//
//  Created by hasegawa-yusuke on 07/31/2019.
//  Copyright (c) 2019 hasegawa-yusuke. All rights reserved.
//

import UIKit
import FirebaseCodable
import FirebaseFirestore

class ViewController: UIViewController {

    private let decoder: FCJSONDecoder = .init(keyDecoding: .convertFromSnakeCase, dateDecoding: .millisecondsSince1970)
    
    private var messages: [Message] = []
    private var lastSnapshot: DocumentSnapshot?
    private var canLoadMore: Bool {
        return lastSnapshot == nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //get data
        let query = Firestore.firestore()
            .collection("messages")
            .order(by: "date", descending: true)
        query.getDocumentsResponse(Message.self, limit: 2, decoder: decoder, from: nil) { [unowned self] result in
            switch result {
            case .success(let response):
                self.messages = response.items
                self.lastSnapshot = response.lastSnapshot
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    self.loadMoreIfPossible()
                })
                
            case .failure(let error):
                debugPrint(error)
            }
        }
        
    }

}

private extension ViewController {
    
    func loadMoreIfPossible() {
        
        guard canLoadMore else {
            debugPrint("no more data")
            return
        }
        
        //get data
        let query = Firestore.firestore()
            .collection("messages")
            .order(by: "date", descending: true)
        query.getDocumentsResponse(Message.self, limit: 2, decoder: decoder, from: lastSnapshot) { result in
            switch result {
            case .success(let response):
                self.messages += response.items
                self.lastSnapshot = response.lastSnapshot
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    self.loadMoreIfPossible()
                })
                
            case .failure(let error):
                debugPrint(error)
            }
        }
        
    }
    
}

