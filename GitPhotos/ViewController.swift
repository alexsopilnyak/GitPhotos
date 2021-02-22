//
//  ViewController.swift
//  GitPhotos
//
//  Created by Alexandr Sopilnyak on 21.02.2021.
//

import UIKit
import WebKit

class ViewController: UIViewController {
  
  let state = UUID().uuidString
  
  lazy var loginButton: UIButton = {
    let button = UIButton()
    button.setTitle("Login with GitHub", for: .normal)
    button.setTitleColor(.systemBlue, for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.frame = CGRect(origin: view.center, size: CGSize(width: 50, height: 200))
    button.addTarget(self, action: #selector(buttonPressed), for: .touchDown)
  return button
  }()
  
  lazy var webView: WKWebView = {
    let webView = WKWebView()
    webView.translatesAutoresizingMaskIntoConstraints = false
    return webView
  }()
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.addSubview(loginButton)
    NSLayoutConstraint.activate([
                                  loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                  loginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)])
   
  }

  
  func startGitAuth() {
    webView.navigationDelegate = self
    view.addSubview(webView)
    NSLayoutConstraint.activate([webView.topAnchor.constraint(equalTo: view.topAnchor),
                                 webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                                 webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                 webView.trailingAnchor.constraint(equalTo: view.trailingAnchor)])


    let parameters = AuthParameters(clientID: APIData.clientID, redirectURI: APIData.redirectURI, state: state, scope: APIData.scope)
    guard let authRequest = AuthCodeRequest(url: APIData.authURL, method: .get, parameters: parameters, headers: nil).create() else {return}
   


    webView.load(authRequest)
    
    
  }

  
  
}

extension ViewController {
  @objc private func buttonPressed(_ sender: UIButton) {
    startGitAuth()
  }
}


extension ViewController: WKNavigationDelegate {
  func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
   
    let url = navigationAction.request.url!
    print(url.absoluteString)
    print("_________________")
    let code = getCodeFromUrl(url: url)
    print(code)
    if let code = code {
      
      let tokenParams = TokenParameters(clientID: APIData.clientID, clientSecret: APIData.clientSecret, redirectURI: APIData.redirectURI, state: state, code: code)
      let tokenRequest = UserTokenRequest(url: APIData.tokenURL, method: .post, parameters: tokenParams).create()!
      let _ = URLSession.shared.dataTask(with: tokenRequest) { (data, response, error) in
        
        do {
          let token = try JSONDecoder().decode(Token.self, from: data!)
          print(token.accessToken)
        }
        catch {
          print(error)
        }
        
      }.resume()
      decisionHandler(.cancel)
      webView.removeFromSuperview()
    } else {
      decisionHandler(.allow)
    }
  }
  
  func getCodeFromUrl(url: URL) -> String? {
      let components = URLComponents(url: url, resolvingAgainstBaseURL: true)
      let code = components?.queryItems?.first(where: { $0.name == "code" })?.value
     // let state = components?.queryItems?.first(where: { $0.name == "state" })?.value
      
      if let code = code {
          return code
      } else {
          return nil
      }
  }
  
}
