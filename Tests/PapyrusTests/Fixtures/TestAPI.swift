import Foundation
import Papyrus

final class TestAPI: API {
    @URLForm
    @HeaderWrapper
    @HeaderWrapper(name: "one", value: "1")
    @HeaderWrapper(name: "two", value: "2")
    @HeaderWrapper(name: "three", value: "3")
    @HeaderWrapper(name: "four", value: "4")
    @HeaderWrapper(name: "five", value: "5")
    @PUT("/body")
    var stacked = Endpoint<Empty, Empty>()
    
    @URLForm
    @JSON
    @PUT("/body")
    var override = Endpoint<Empty, Empty>()
    
    @CUSTOM(method: "FOO", "/foo")
    var custom = Endpoint<Empty, Empty>()
    
    @DELETE("/delete")
    var delete = Endpoint<Empty, Empty>()
    
    @GET("/get")
    var get = Endpoint<Empty, Empty>()
    
    @PATCH("/patch")
    var patch = Endpoint<Empty, Empty>()
    
    @POST("/post")
    var post = Endpoint<Empty, Empty>()
    
    @OPTIONS("/options")
    var options = Endpoint<Empty, Empty>()
    
    @TRACE("/trace")
    var trace = Endpoint<Empty, Empty>()
    
    @CONNECT("/connect")
    var connect = Endpoint<Empty, Empty>()
    
    @HEAD("/head")
    var head = Endpoint<Empty, Empty>()
}