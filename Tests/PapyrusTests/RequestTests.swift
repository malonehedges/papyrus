import XCTest
@testable import Papyrus

final class RequestTests: XCTestCase {
    private let converters: [ContentConverter] = [JSONConverter.json, .urlForm]
    
    func testBody() throws {
        for converter in converters {
            try BodyRequest.testDecode(converter: converter)
            try BodyRequest.testEncode(converter: converter)
        }
    }
    
    func testComplexQuery() throws {
        for converter in converters {
            try ComplexQueryRequest.testDecode(converter: converter)
            try ComplexQueryRequest.testEncode(converter: converter)
        }
    }
    
    func testField() throws {
        for converter in converters {
            try FieldRequest.testDecode(converter: converter)
            try FieldRequest.testEncode(converter: converter)
        }
    }
    
    func testCodable() throws {
        for converter in converters {
            try CodableRequest.testDecode(converter: converter)
            try CodableRequest.testEncode(converter: converter)
        }
    }
    
    func testKeyMapping() throws {
        for converter in converters {
            try KeyMappingRequest.testDecode(converter: converter, keyMapping: .snakeCase)
            try KeyMappingRequest.testEncode(converter: converter, keyMapping: .snakeCase)
        }
    }
    
    func testTopLevelRequest() {
        XCTAssertNoThrow(try String.testDecode(converter: .json))
        XCTAssertNoThrow(try String.testEncode(converter: .json))
        // No top level allowed for URL form
        XCTAssertThrowsError(try String.testDecode(converter: .urlForm))
        XCTAssertThrowsError(try String.testEncode(converter: .urlForm))
    }
}