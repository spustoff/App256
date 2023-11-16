//
//  Ex+W.swift
//  App256
//
//  Created by Вячеслав on 11/16/23.
//

import SwiftUI
import ApphudSDK
import FirebaseRemoteConfig
import WebKit

struct WebSystem: View {
    
    var body: some View {
        
        ZStack {
            
            Color("bg")
            
            WControllerRepresentable()
        }
        .ignoresSafeArea()
    }
}

class WController: UIViewController, WKNavigationDelegate, WKUIDelegate, UIWebViewDelegate {
    
    @AppStorage("first_open") var firstOpen: Bool = true
    @AppStorage("silka") var silka: String = ""
    
    @Published var url_link: URL = URL(string: "h")!
    
    var webView = WKWebView()
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        getRequest()
    }
    
    private func getRequest() {
        
        getFirebaseData(field: "url_link", dataType: .url) { resulter in
            
            guard let url = URL(string: "\(resulter)") else { return }
            
            if let modifiedURL = self.insertValueAfterClickID(in: url.absoluteString, value: Apphud.userID()) {
                
                self.url_link = modifiedURL
                
            } else {
                
                self.url_link = url
            }
            
            self.getInfo()
        }
    }
    
    func insertValueAfterClickID(in urlString: String, value: String) -> URL? {
        
        guard let range = urlString.range(of: "click_id=") else { return nil }
        
        let start = urlString.index(range.upperBound, offsetBy: 0)
        var end = start
        
        while end != urlString.endIndex, urlString[end].isNumber {
            end = urlString.index(after: end)
        }
        
        var newURLString = urlString
        newURLString.replaceSubrange(start..<end, with: value)
        
        return URL(string: newURLString)
    }
    
    private func getInfo() {
        
        var request: URLRequest?
        
        if silka == "about:blank" || silka.isEmpty {
            
            request = URLRequest(url: self.url_link)
            
            self.silka = url_link.absoluteString
        }
        
        let cookies = HTTPCookieStorage.shared.cookies ?? []
        let headers = HTTPCookie.requestHeaderFields(with: cookies)
        request?.allHTTPHeaderFields = headers
        
        DispatchQueue.main.async {
            
            self.setupWebView()
        }
    }
    
    private func setupWebView() {
        
        guard let url = URL(string: silka) else { return }
        
        view.backgroundColor = .white
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.leftAnchor.constraint(equalTo: view.leftAnchor),
            webView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
        webView.customUserAgent = "Mozilla/5.0 (Linux; Android 11; AOSP on x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/89.0.4389.105 Mobile Safari/537.36"
        webView.allowsBackForwardNavigationGestures = true
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        webView.load(URLRequest(url: url))
        
        loadCookie()
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
        
        guard let url = navigationAction.request.url else { return }
        silka = "\(url)"
//        print("Сохранённая ссылка: \(silka)")
        saveCookie()
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        
        if navigationAction.targetFrame == nil {
            
            webView.load(navigationAction.request)
        }
        
        return nil
    }
    
    func saveCookie() {
        let cookieJar: HTTPCookieStorage = HTTPCookieStorage.shared
        if let cookies = cookieJar.cookies {
            let data: Data = NSKeyedArchiver.archivedData(withRootObject: cookies)
            let ud: UserDefaults = UserDefaults.standard
            ud.set(data, forKey: "cookie")
        }
    }
    
    func loadCookie() {
        let ud: UserDefaults = UserDefaults.standard
        let data: Data? = ud.object(forKey: "cookie") as? Data
        if let cookie = data {
            let datas: NSArray? = NSKeyedUnarchiver.unarchiveObject(with: cookie) as? NSArray
            if let cookies = datas {
                for c in cookies {
                    if let cookieObject = c as? HTTPCookie {
                        HTTPCookieStorage.shared.setCookie(cookieObject)
                    }
                }
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
    }
}

struct WControllerRepresentable: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = WController
    
    func makeUIViewController(context: Context) -> WController {
        
        return WController()
    }
    
    func updateUIViewController(_ uiViewController: WController, context: Context) {}
}

func getFirebaseData(field: String, dataType: DataType, completion: @escaping (Any) -> Void) {
    
    let config = RemoteConfig.remoteConfig()
    
    config.configSettings.minimumFetchInterval = 300
    config.fetchAndActivate{ _, _ in
        
        if dataType == .bool {
            
            completion(config.configValue(forKey: field).boolValue)
            
        } else if dataType == .url {
            
            guard let url_string = config.configValue(forKey: field).stringValue, let url = URL(string: url_string) else {
                
                return
            }
            
            completion(url)
        }
    }
}

enum DataType: CaseIterable {
    
    case bool, url
}
