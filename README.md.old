# FirebaseCodable

[![CI Status](https://img.shields.io/travis/hasegawa-yusuke/FirebaseCodable.svg?style=flat)](https://travis-ci.org/hasegawa-yusuke/FirebaseCodable)
[![Version](https://img.shields.io/cocoapods/v/FirebaseCodable.svg?style=flat)](https://cocoapods.org/pods/FirebaseCodable)
[![License](https://img.shields.io/cocoapods/l/FirebaseCodable.svg?style=flat)](https://cocoapods.org/pods/FirebaseCodable)
[![Platform](https://img.shields.io/cocoapods/p/FirebaseCodable.svg?style=flat)](https://cocoapods.org/pods/FirebaseCodable)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements
- Firebase

## Installation

FirebaseCodable is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'FirebaseCodable', :git => 'https://github.com/usk2000/FirebaseCodable' 
```

## Usage
### define struct
```ruby
struct Message: FirebaseCodable {
  let id: String
  let text: String
  let date: Date
  let additional: String?
}
```
### create Reference or Query
See below links:
[Add and Manage data](https://firebase.google.com/docs/firestore/manage-data/structure-data)
[Read data](https://firebase.google.com/docs/firestore/query-data/get-data)

### create decoder or encoder

```
let decoder: FCJSONDecoder = .init(keyDecoding: .convertFromSnakeCase, dateDecoding: .millisecondsSince1970)
let encoder: FCJSONEncoder = .init(keyEncoding: .convertToSnakeCase, dateEncoding: .millisecondsSince1970)
```
`FCJSONDecoder` and `FCJSONEncoder` are subclass of `JSONDecoder` and `JSONEncoder`
See below link for more detail:
https://developer.apple.com/documentation/foundation/jsondecoder
https://developer.apple.com/documentation/foundation/jsonencoder

### do operation

#### get data
```
//query
let query = Firestore.firestore()
  .collection("messages")
  .order(by: "date", descending: true)
  
//get data
query.getDocumentsAs(Message.self, decoder: decoder) { result in
  switch result {
  case .success(let messages):
  debugPrint("num of message : \(messages.count)")
  
  case .failure(let error):
  debugPrint(error)
  }
}
  
```
#### get single document

```
let ref = Firestore.firestore().collection("messages").document("some_message_id")
ref.getDocumentAs(Message.self, decoder: decoder) { result in
  switch result {
  case .success(let response):
    if let message = response {
      debugPrint(message)
    } else {
      debugPrint("not found")
    }

  case .failure(let error):
    debugPrint(error)
  }
}
```

#### save data
```
let message = Message(id: "ignored", text: "bra-bra", date: Date())
let newRef = Firestore.firestore().collection("messages").document() //new document with auto-generated ID
newRef.setDataAs(message, encoder: encoder) { result in
  switch result {
  case .success:
    debugPrint("success to save")

  case .failure(let error):
    debugPrint(error)
  }
}
```

#### update data
```
let fields: [String: Any] = [
  "text": "new text, bra-bra"
]

ref.updateData(fields: fields) { result in
  switch result {
  case .success:
    debugPrint("success to update")
    
  case .failure(let error):
    debugPrint(error)
  }
}
```

#### delete data
```
ref.deleteDocument { result in
  switch result {
  case .success:
    debugPrint("success to delete")

  case .failure(let error):
    debugPrint(error)
  }
}
```

## Author

Yuusuke Hasegawa, hasegawa.allround@gmail.com

## License

FirebaseCodable is available under the MIT license. See the LICENSE file for more info.
