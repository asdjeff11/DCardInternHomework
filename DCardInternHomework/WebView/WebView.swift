//
//  WebView.swift
//  DCardInternHomework
//
//  Created by 楊宜濱 on 2023/3/9.
//

import Foundation
import UIKit
import WebKit
class WebView:UIViewController {
    var url_str = ""
    private var mWebView = WKWebView()
    private var backBtn = UIButton()
    private var fowardBtn = UIButton()
    private var recordRow = 0
    private var isLoading = false
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex:0x00324e)
        setUp()
        layout()
        if let url = URL(string: url_str) {
            let urlRequest = URLRequest(url: url)
            self.mWebView.load(urlRequest)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.mWebView.stopLoading()
    }
}

extension WebView {
    private func setUp() {
        setUpNav(title: "導覽頁",backButtonVisit: true)
        
        mWebView.navigationDelegate = self // 委任函數
        
        backBtn.isEnabled = false
        backBtn.setTitle("上一頁", for: .normal)
        backBtn.setTitleColor(.white, for: .normal)
        backBtn.backgroundColor = Theme.navigationBarBG
        backBtn.layer.cornerRadius = 10
        backBtn.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        
        fowardBtn.isEnabled = false
        fowardBtn.setTitle("下一頁", for: .normal)
        fowardBtn.setTitleColor(.white, for: .normal)
        fowardBtn.backgroundColor = Theme.navigationBarBG
        fowardBtn.layer.cornerRadius = 10
        fowardBtn.addTarget(self, action: #selector(goFoward), for: .touchUpInside)
    }
    
    private func layout() {
        let margins = view.layoutMarginsGuide
        view.addSubviews(/*backBtn ,fowardBtn , */ mWebView)
        NSLayoutConstraint.useAndActivateConstraints(constraints: [
            /*backBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 30 * Theme.factor),
            backBtn.widthAnchor.constraint(equalToConstant: 150 * Theme.factor),
            backBtn.topAnchor.constraint(equalTo: margins.topAnchor,constant: 10 * Theme.factor),
            backBtn.heightAnchor.constraint(equalToConstant: 30),
        
            fowardBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -30 * Theme.factor),
            fowardBtn.widthAnchor.constraint(equalTo: backBtn.widthAnchor),
            fowardBtn.centerYAnchor.constraint(equalTo: backBtn.centerYAnchor),
            fowardBtn.heightAnchor.constraint(equalTo: backBtn.heightAnchor),
            */
            mWebView.topAnchor.constraint(equalTo: margins.topAnchor),
            mWebView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mWebView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mWebView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension WebView {
    @objc private func goFoward() {
        self.mWebView.goForward()
    }
    
    @objc private func goBack() {
        self.mWebView.goBack()
    }
}

extension WebView:WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("start load")
        loading(isLoading: &isLoading)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("load finish")
        removeLoading(isLoading: &isLoading)
        fowardBtn.isEnabled = webView.canGoForward
        backBtn.isEnabled = webView.canGoBack
    }
    
    /*func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping(WKNavigationActionPolicy)->Void) {
        // 針對 html5 target = "_blank" 開啟新分頁方式處理
        if ( navigationAction.targetFrame == nil ) {
            decisionHandler(.cancel) // 取消預設行為
            webView.load(navigationAction.request) // 載入收到的新urlRequest
            return
        }
        
        decisionHandler(.allow) //預設行為
    }*/
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        // 針對 js window.open 開啟新分頁方式處理
        if ( navigationAction.targetFrame == nil || navigationAction.targetFrame?.isMainFrame == nil ) {
            webView.load(navigationAction.request) // 原先的載入
        }
        return nil // 不開新的webView
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, preferences: WKWebpagePreferences, decisionHandler: @escaping (WKNavigationActionPolicy, WKWebpagePreferences) -> Void) {
        if navigationAction.shouldPerformDownload {
            decisionHandler(.download, preferences)
        }
        else if ( navigationAction.targetFrame == nil || navigationAction.targetFrame?.isMainFrame == nil) {
            decisionHandler(.cancel, preferences)
            webView.load(navigationAction.request)
        }
        else {
            decisionHandler(.allow, preferences)
        }
    }
    
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        if navigationResponse.canShowMIMEType {
            decisionHandler(.allow)
        } else {
            decisionHandler(.download)
        }
    }
}

