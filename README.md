# FirebaseCodable

Firestore with Codable

## Integration

### Using Swift Package Manager
- add this repository from your Xcode

### Manual Integration
- Download source
- drag & drop Sources/FirebaseCodable folder into your project.


## Usage

### Define model with confirms FirestoreCodable

`FirestoreCodable` is extension of `Codable`, which has `id` parameter.

```
public protocol FirestoreCodable: Codable {
    var id: String { get }
}
```

You can define model as:
```
struct SampleModel: FirestoreCodable, Equatable {
    var id: String
    let title: String
    let date: Date
}
```

### Single document

#### Get
```
let ref = firestore.collection("samples").document("single_document")

ref.getDocumentAs(SampleModel.self, decoder: FCDefaultJSONDecoder()) { result in
    switch result {
    case .success(let response):
        //success
    case .failure(let error):
        //error
    }
}
```

#### Set

```
let ref = firestore.collection("samples").document()

let model = SampleModel.init(id: "tmp", title: "sample text", date: Date())

ref.setDataAs(model, encoder: FCDeafaultJSONEncoder()) { result in
    switch result {
    case .success:
        //success        
    case .failure(let error):
        //error
    }
}
```

#### Update
```
let ref = firestore.collection("samples").document("single_document")
ref.updateData(fields: ["date": Date()]) { result in
    switch result {
    case .success:
        //success        
    case .failure(let error):
        //error
    }
}
```
#### Delete

```
let ref = firestore.collection("samples").document("single_document")
ref.delete { result in
    switch result {
    case .success:
        //success        
    case .failure(let error):
        //error
    }
}
```

#### Observe update

```
let ref = firestore.collection("samples").document("single_document")
listener = ref.addUpdateListenerAs(SampleModel.self, decoder: decoder) { result in
    switch result {
    case .success(let response):
        //updated        
    case .failure(let error):
        //error
    }
}
```

### Multiple documents

#### Get

```
let query = firestore.collection("samples")
    .order(by: "date", descending: true)
    .limit(to: 10)

query.getDocumentResponseAs(SampleModel.self, source: .default, decoder: FCDefaultJSONDecoder()) { [weak self] result in
    switch result {
    case .success(let response):        
        //response.items: [SampleModel]
        //response.lastSnapshot: DocumentSnapshot, which used for cursor        
    case .failure(let error):
        //error
    }
}
```

#### Observe update

```
//observe only first document for this sample
let query = firestore.collection("samples")
    .order(by: "date", descending: true)
    .limit(to: 1)

listener = query.addSnapshotListenerAs(SampleModel.self, decoder: FCDefaultJSONDecoder()) { result in
    switch result {
    case .success(let snapshotDiff):
        
        debugPrint("added    : \(snapshotDiff.added.count)")
        debugPrint("modified : \(snapshotDiff.modified.count)")
        debugPrint("removed  : \(snapshotDiff.removed.count)")
        
        //apply changes
        FCSnapshotDiff.apply(diffs: snapshotDiff, value: &samples)
        
    case .failure(let error):
        debugPrint(error)
    }
}
```

### Define custom JSON encoder/decoder

```
class CustomDecoder: JSONDecoder, FCJsonDecoderProtocol {
    
    override init() {
        super.init()
        self.keyDecodingStrategy = .convertFromSnakeCase
        self.dateDecodingStrategy = .millisecondsSince1970
    }
    
}
```

## Demo Project
https://github.com/usk2000/FirebaseCodableDemo

## LICENSE
[LICENSE](LICENSE)
