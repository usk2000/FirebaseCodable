//
//  FCSnapshotDiff.swift
//  FirebaseCodable
//
//  Created by hasegawa-yusuke on 2019/08/01.
//

import Foundation

/// SnapshotDiff
public struct FCSnapshotDiff<T> {
    public let added: [T]
    public let modified: [T]
    public let removed: [T]
}

public extension FCSnapshotDiff where T: FirestoreCodable, T: Equatable {
    
    /// apply diff
    /// - Parameters:
    ///   - diffs: diffs
    ///   - value: value to apply
    /// - Returns: bool
    @discardableResult
    static func apply(diffs: FCSnapshotDiff<T>, value: inout [T]) -> Bool {
        var modified = false
        
        if !diffs.added.isEmpty {
            modified = true
            value.insert(contentsOf: diffs.added.filter({ value.firstIndex(of: $0) == nil }), at: 0)
        }
        
        if !diffs.modified.isEmpty {
            modified = true
            diffs.modified.forEach({ val in
                if let index = value.firstIndex(of: val) {
                    value[index] = val
                }
            })
        }
        
        if !diffs.removed.isEmpty {
            modified = true
            let indexs = diffs.removed.compactMap({ value.firstIndex(of: $0) }).reversed()
            indexs.forEach({ value.remove(at: $0) })
        }
        
        return modified
    }
    
}
