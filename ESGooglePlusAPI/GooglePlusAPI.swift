//
//  GooglePlusAPI.swift
//  CodePiece
//
//  Created by Tomohiro Kumagai on 11/4/16.
//  Copyright © 2016 EasyStyle G.K. All rights reserved.
//

import Foundation
import WebKit

public final class GooglePlusAPI : NSObject {
	
	private let workspace = WKWebView()
	private let navigationDelegate = NavigationDelegate()
	
	private final class NavigationDelegate : NSObject, WKNavigationDelegate {
		
	}
	
	public override init() {
		
		super.init()

		workspace.navigationDelegate = navigationDelegate
		
		print("🐋 EXPERIMENTAL: Initialized")
	}
}

extension GooglePlusAPI.NavigationDelegate {
	
	func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
		
		print("🐋 EXPERIMENTAL: View did finish navigation !")
	}
	
	private func webView(webView: WKWebView, didFailNavigation navigation: WKNavigation!, withError error: NSError) {

		print("🐋 EXPERIMENTAL: Fail navigation ! (\(error))")
	}
}

extension GooglePlusAPI {

	private static let topPage = NSURL(string: "https://plus.google.com")!
	
	public func login() {
		
		let request = NSURLRequest(URL: GooglePlusAPI.topPage)
		
		print("🐋 EXPERIMENTAL: Try Loading...")
		workspace.loadRequest(request)
	}
}