//
//  PreferencesWindowController.swift
//  CodePiece
//
//  Created by Tomohiro Kumagai on H27/07/21.
//  Copyright © 平成27年 EasyStyle G.K. All rights reserved.
//

import Cocoa

class PreferencesWindowController: NSWindowController {

	@IBOutlet weak var toolbar:NSToolbar!
	
	@IBAction func showGitHubPreference(sender:NSToolbarItem?) {
	
		self.contentViewController = Storyboard.GitHubPreferenceView.defaultViewController
	}
	
	@IBAction func showTwitterPreference(sender:NSToolbarItem?) {
		
		self.contentViewController = Storyboard.TwitterPreferenceView.defaultViewController
	}
	
    override func windowDidLoad() {

		super.windowDidLoad()

		self.contentViewController = Storyboard.GitHubPreferenceView.defaultViewController
    }
}

extension PreferencesWindowController : NSWindowDelegate {
	
	func windowWillClose(notification: NSNotification) {
		
		NSApp.stopModal()
	}
}