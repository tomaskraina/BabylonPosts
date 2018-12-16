//
//  SafelyDecodableArray.swift
//  BabylonHealth
//
//  Created by Tom Kraina on 14/12/2018.
//  Copyright © 2018 Tom Kraina. All rights reserved.
//

import Foundation

/// Wrapper for an array with decodable elements
///
/// Use this wrapper instead of Array<Element: Decodable>
/// when you want to silently skip elements that can't be decoded.
///
/// Inspired by https://stackoverflow.com/questions/46344963
struct SafelyDecodableArray<ElementType: Codable> {
    typealias WrappedType = [ElementType]
    
    private let elements: WrappedType
    let decodingErrors: [Error]
    
    init(elements: WrappedType) {
        self.elements = elements
        self.decodingErrors = []
    }
}

// MARK: - SafelyDecodableArray: Codable
extension SafelyDecodableArray: Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let elements = try container.decode([DecodableResult<WrappedType.Element>].self)
        self.elements = elements.compactMap { $0.value }
        self.decodingErrors = elements.compactMap { $0.error }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(elements)
    }
}

// MARK: - SafelyDecodableArray: Collection
extension SafelyDecodableArray: Collection {
    
    typealias Index = WrappedType.Index
    typealias Element = WrappedType.Element
    
    var startIndex: Index { return elements.startIndex }
    var endIndex: Index { return elements.endIndex }
    
    subscript(index: Index) -> Element {
        get { return elements[index] }
    }
    
    func index(after i: Index) -> Index {
        return elements.index(after: i)
    }
    
    func makeIterator() -> IndexingIterator<WrappedType> {
        return elements.makeIterator()
    }
}
