//
//  ViewController.swift
//  GitPhotos
//
//  Created by Alexandr Sopilnyak on 21.02.2021.
//

import UIKit
import WebKit

class LoginViewController: UIViewController {
  
  private let authService = ServiceFactory.shared.makeAuthService()
  
  private lazy var loginButton: UIButton = {
    let button = UIButton()
    button.setTitle("Login with GitHub", for: .normal)
    button.setTitleColor(.systemBlue, for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.frame = CGRect(origin: view.center, size: CGSize(width: 50, height: 200))
    button.addTarget(self, action: #selector(buttonPressed), for: .touchDown)
    return button
  }()
  
  private lazy var webView: WKWebView = {
    let webView = WKWebView()
    webView.translatesAutoresizingMaskIntoConstraints = false
    return webView
  }()
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureWebView()
    configureLoginButton()
  }

}

private extension LoginViewController{
  func configureWebView() {
    webView.navigationDelegate = self
    view.addSubview(webView)
    NSLayoutConstraint.activate([webView.topAnchor.constraint(equalTo: view.topAnchor),
                                 webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                                 webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                 webView.trailingAnchor.constraint(equalTo: view.trailingAnchor)])
  }
  
  
  func configureLoginButton() {
    view.addSubview(loginButton)
    NSLayoutConstraint.activate([
                                  loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                  loginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)])
  }
  
  
  func startGitAuth() {
  
    guard let safeRedirectURI = APIData.redirectURI else { return }
    guard let safeAuthURL = APIData.authURL else { return }
    let parameters = AuthParameters(clientID: APIData.clientID, redirectURI: safeRedirectURI, state: APIData.userState, scope: APIData.scope)
    guard let authRequest = AuthCodeRequest(url: safeAuthURL, method: .get, parameters: parameters, headers: nil).create() else { return }
    
    webView.load(authRequest)
  
  }
  
  @objc func buttonPressed(_ sender: UIButton) {
    startGitAuth()
  }
}


extension LoginViewController: WKNavigationDelegate {
  func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
    
    decisionHandler(.allow)
    guard let url = navigationAction.request.url else {
      decisionHandler(.cancel)
      return
    }
    
    let code = authService.getAuthCode(from: url)
    
    guard let authCode = code else {return}
    
    authService.getAccessToken(from: authCode) { (authToken, error) in
      
      guard let tokenData = authToken.token.data(using: .utf8) else { return }
      let _ = KeyChainService.save(key: Constants.kAccessToken, data: tokenData)
      
      webView.removeFromSuperview()
      
      if let vc = self.storyboard?.instantiateViewController(identifier: RepositoryListViewController.reuseIdOrClassName) {
        self.navigationController?.pushViewController(vc, animated: true)
      }
      
    }
  }
}


