//
//  AuthorizationCoordinator.swift
//  GitHub Searcher
//
//  Created by Daniyar Merekeyev on 30.07.2025.
//

import Foundation
import AuthenticationServices

final class AuthorizationCoordinator: NSObject, ASWebAuthenticationPresentationContextProviding {
    private let useCase: AuthorizationUseCase
    private let completion: (String?) -> Void
    private var session: ASWebAuthenticationSession?

    init(useCase: AuthorizationUseCase, completion: @escaping (String?) -> Void) {
        self.useCase = useCase
        self.completion = completion
    }

    func startAuthorization() {
        guard let url = useCase.authorizationURLRequest.url else {
            print("invalid authorization URL")
            completion(nil)
            return
        }

        session = ASWebAuthenticationSession(url: url,
                                             callbackURLScheme: "githubsearcher") { [weak self] callbackURL, error in
            guard let self,
                  error == nil,
                  let callbackURL,
                  let queryItems = URLComponents(string: callbackURL.absoluteString)?.queryItems,
                  let code = queryItems.filter({ $0.name == "code" }).first?.value else {
                print("authorization error - \(error?.localizedDescription ?? "")")
                self?.completion(nil)
                return
            }

            self.completion(code)
        }

        session?.presentationContextProvider = self
        session?.prefersEphemeralWebBrowserSession = true
        session?.start()
    }

    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow } ?? ASPresentationAnchor()
    }
    
    deinit {
        print("Deinit - \(Self.self)")
    }
}
