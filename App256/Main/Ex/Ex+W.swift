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

class WController: UIViewController, WKNavigationDelegate, WKUIDelegate {

    @AppStorage("first_open") var firstOpen: Bool = true
    @AppStorage("silka") var silka: String = ""
    
    @Published var url_link: URL = URL(string: "h")!
    
    var webView = WKWebView()
    var redirectTimer: Timer?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        getRequest()
    }
    
    private func getRequest() {
        
        getFirebaseData(field: "url_link", dataType: .url) { resulter in
            
            guard let url = URL(string: "\(resulter)") else { return }

            if let modifiedURL = self.insertValueAfterClickID(in: "\(resulter)", with: Apphud.userID()) {
                
                self.url_link = modifiedURL
                
            } else {
                
                self.url_link = url
            }
            
            if self.firstOpen {
                
                self.firstOpen = false
                
                if self.url_link.absoluteString.contains("thread") || self.url_link.absoluteString.contains("td") {
                    
                    self.startRedirectTimer()
                }
            }
            
            self.getInfo()
        }
    }
    
    func insertValueAfterClickID(in urlString: String, with value: String) -> URL? {
        var newURLString = urlString

        if let range = urlString.range(of: "click_id=") {
            let existingIDEnd = urlString[range.upperBound...].firstIndex(where: { !$0.isNumber }) ?? urlString.endIndex
            let insertionPoint = urlString.index(range.upperBound, offsetBy: urlString.distance(from: range.upperBound, to: existingIDEnd))
            newURLString.insert(contentsOf: value, at: insertionPoint)
        } else {
            let separator = urlString.contains("?") ? "&" : "?"
            newURLString += "\(separator)click_id=\(value)"
        }
        
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
        
        silka = "\(url)"
        saveCookie()
        
        print("silka 1: \(url)")
        
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
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        guard let url = navigationAction.request.url else {
            
            decisionHandler(.cancel)
            
            return
        }

        if !url.absoluteString.contains("widgets") && url.absoluteString != "about:blank" && url.absoluteString != "about:srcdoc" && !url.absoluteString.contains("google") {
            
            self.silka = url.absoluteString
            
            self.saveCookie()
            
            print("saved url: \(self.silka)")
        }
        
        print("url: \(self.silka)")
        
        decisionHandler(.allow)
    }
    
    private func startRedirectTimer() {
        redirectTimer?.invalidate()
        redirectTimer = Timer.scheduledTimer(timeInterval: 7.0, target: self, selector: #selector(checkForRedirect), userInfo: nil, repeats: false)
    }

    @objc private func checkForRedirect() {
        
        if let currentURL = webView.url, !currentURL.absoluteString.contains("widgets") {
            
            silka = currentURL.absoluteString
            
            UserDefaults.standard.set(silka, forKey: "lastURL")
        }
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
