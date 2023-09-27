import XCTest
@testable import PapyrusPlugin
import MacroTesting

final class PluginTest: XCTestCase {
  func testOnlyProtocols() throws {
    assertMacro(["API": APIMacro.self]) {
      """
      @API
      struct MyService {
      }
      """
    } matches: {
      """
      struct MyService {
      }

      PapyrusPluginError(message: "@API can only be applied to protocols.")
      """
    }
  }
  
  func testDefaultsToQuery() throws {
    assertMacro(["API": APIMacro.self]) {
      """
      @API
      protocol MyService {
        @GET("some/path")
        func myQuery(id userId: String) async throws -> String
      }
      """
    } matches: {
      """
      protocol MyService {
        @GET("some/path")
        func myQuery(id userId: String) async throws -> String
      }

      struct MyServiceAPI: MyService {
          private let provider: Provider

          init(provider: Provider) {
              self.provider = provider
          }

          func myQuery(id userId: String) async throws -> String {
            var req = builder(method: "GET", path: "some/path")
            req.addQuery("userId", value: userId)
            let res = try await provider.request(req)
            return try res.decode(String.self, using: req.responseDecoder)
          }

          private func builder(method: String, path: String) -> RequestBuilder {
            provider.newBuilder(method: method, path: path)
          }
      }
      """
    }
  }
  
  func testOverrideToField() throws {
    assertMacro(["API": APIMacro.self]) {
      """
      @API
      protocol MyService {
        @GET("some/path")
        func myQuery(id userId: Field<Int>) async throws -> String
      }
      """
    } matches: {
      """
      protocol MyService {
        @GET("some/path")
        func myQuery(id userId: Field<Int>) async throws -> String
      }

      struct MyServiceAPI: MyService {
          private let provider: Provider

          init(provider: Provider) {
              self.provider = provider
          }

          func myQuery(id userId: Field<Int>) async throws -> String {
            var req = builder(method: "GET", path: "some/path")
            req.addField("userId", value: userId)
            let res = try await provider.request(req)
            return try res.decode(String.self, using: req.responseDecoder)
          }

          private func builder(method: String, path: String) -> RequestBuilder {
            provider.newBuilder(method: method, path: path)
          }
      }
      """
    }
  }
  
  func testQuery_GET() throws {
    assertMacro(["API": APIMacro.self]) {
      """
      enum Since: String, Codable {
        case one, two, three
      }
      @API
      protocol MyService {
        @GET("users/:userId")
        func getUser(userId: Path<String>, since: Query<Since>) async throws -> String
      }
      """
    } matches: {
      """
      enum Since: String, Codable {
        case one, two, three
      }
      protocol MyService {
        @GET("users/:userId")
        func getUser(userId: Path<String>, since: Query<Since>) async throws -> String
      }
      
      struct MyServiceAPI: MyService {
          private let provider: Provider
      
          init(provider: Provider) {
              self.provider = provider
          }
      
          func getUser(userId: Path<String>, since: Query<Since>) async throws -> String {
            var req = builder(method: "GET", path: "users/:userId")
            req.addParameter("userId", value: userId)
            req.addQuery("since", value: since)
            let res = try await provider.request(req)
            return try res.decode(String.self, using: req.responseDecoder)
          }
      
          private func builder(method: String, path: String) -> RequestBuilder {
            provider.newBuilder(method: method, path: path)
          }
      }
      """
    }
  }
  
  // This test currently fails
  // Actual output (+) differed from expected output (−).
  // −       req.addQuery("since", value: since)
  // +       req.addField("since", value: since)
  func testQuery_POST() throws {
    assertMacro(["API": APIMacro.self]) {
      """
      enum Since: String, Codable {
        case one, two, three
      }
      @API
      protocol MyService {
        @POST("users/:userId")
        func getUser(userId: Path<String>, since: Query<Since>) async throws -> String
      }
      """
    } matches: {
      """
      enum Since: String, Codable {
        case one, two, three
      }
      protocol MyService {
        @POST("users/:userId")
        func getUser(userId: Path<String>, since: Query<Since>) async throws -> String
      }

      struct MyServiceAPI: MyService {
          private let provider: Provider

          init(provider: Provider) {
              self.provider = provider
          }

          func getUser(userId: Path<String>, since: Query<Since>) async throws -> String {
            var req = builder(method: "POST", path: "users/:userId")
            req.addParameter("userId", value: userId)
            req.addQuery("since", value: since)
            let res = try await provider.request(req)
            return try res.decode(String.self, using: req.responseDecoder)
          }

          private func builder(method: String, path: String) -> RequestBuilder {
            provider.newBuilder(method: method, path: path)
          }
      }
      """
    }
  }
}
