import SwiftSyntax

extension ProtocolDeclSyntax {
    var name: String {
        identifier.text
    }
    
    var access: String {
        modifiers?.first.map { "\($0.trimmedDescription) " } ?? ""
    }

    var functions: [FunctionDeclSyntax] {
        memberBlock.members
            .compactMap { $0.decl.as(FunctionDeclSyntax.self) }
    }
}