//
//  WebView.swift
//  SnapFit
//
//  Created by 정정욱 on 7/15/24.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
        webView.configuration.preferences.javaScriptEnabled = true // JavaScript 실행 허용
        return webView
    }


    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}
