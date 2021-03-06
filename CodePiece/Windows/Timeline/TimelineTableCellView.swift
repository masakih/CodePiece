//
//  TimelineTableCellView.swift
//  CodePiece
//
//  Created by Tomohiro Kumagai on H27/08/22.
//  Copyright © 平成27年 EasyStyle G.K. All rights reserved.
//

import Cocoa
import Swim
import ESThread
import ESTwitter

class TimelineTableCellView: NSTableCellView, Selectable {

	private static var cellForEstimateHeight: TimelineTableCellView!
	
	enum Style {
	
		case Recent
		case Past
	}
	
	var item:TimelineTweetItem? {
		
		didSet {
			
			if item?.status.id != oldValue?.status.id {

				self.applyItem(self.item)
			}
		}
	}
	
	var style:Style = .Recent {
		
		didSet {
			
			self.needsDisplay = true
		}
	}
	
	var selected:Bool = false {
		
		didSet {
			
			if self.selected != oldValue {

				self.textLabel.selectable = self.selected
				self.needsDisplay = true
			}
		}
	}
	
	@IBOutlet var usernameLabel:NSTextField!
	@IBOutlet var textLabel:NSTextField!
	@IBOutlet var iconButton:NSButton!
	@IBOutlet var dateLabel:NSTextField!
	@IBOutlet var retweetMark: NSView!

	override func drawRect(dirtyRect: NSRect) {

		if self.selected {

			self.style.selectionBackgroundColor.set()
		}
		else {

			self.style.backgroundColor.set()
		}
		
		NSRectFill(dirtyRect)
		
		super.drawRect(dirtyRect)
	}
	
	private func applyItem(item:TimelineTweetItem?) {

		if let status = item?.status {

			// NOTE: 🐬 CodePiece の Data を扱うときに HTMLText を介すると attributedText の実装が逆に複雑化する可能性があるため、一旦保留にします。
//			let html = HTMLText(rawValue: status.text)
//			self.textLabel.attributedStringValue = html.attributedText

			self.textLabel.attributedStringValue = status.attributedText { text in
				
				let textRange = NSMakeRange(0, text.length)
				
				text.addAttribute(NSFontAttributeName, value: systemPalette.textFont, range: textRange)
				text.addAttribute(NSForegroundColorAttributeName, value: systemPalette.textColor, range: textRange)
			}
			
			let dateToString:(Date) -> String = {
				
				let formatter = tweak(NSDateFormatter()) {
					
					$0.dateStyle = .ShortStyle
					$0.timeStyle = .ShortStyle
//					$0.dateFormat = "yyyy-MM-dd HH:mm"
//					$0.locale = NSLocale(localeIdentifier: "en_US_POSIX")
				}
				
				return formatter.stringFromDate($0.rawValue)
			}
			
			self.usernameLabel.stringValue = status.user.name
			self.dateLabel.stringValue = dateToString(status.createdAt)
			self.iconButton.image = nil
			self.retweetMark.hidden = !status.isRetweetedTweet
			self.style = (status.createdAt > Date().daysAgo(1) ? .Recent : .Past)
			
			self.updateIconImage(status)
		}
		else {

			self.textLabel.attributedStringValue = NSAttributedString(string: "")
			self.usernameLabel.stringValue = ""
			self.dateLabel.stringValue = ""
			self.iconButton.image = nil
			self.retweetMark.hidden = true
			self.style = .Recent
			self.iconButton.image = nil
		}
		
		self.needsDisplay = true
	}
	
	private func updateIconImage(status:ESTwitter.Status) {

		let setImage = { (url: NSURL) in
			
			invokeAsyncInBackground {
				
				if let image = NSImage(contentsOfURL: url) {
					
					invokeAsyncOnMainQueue { self.iconButton.image = image }
				}
				else {
					
					invokeAsyncOnMainQueue { self.iconButton.image = nil }
				}
			}
		}
		
		let resetImage = {
			
			invokeAsyncOnMainQueue {
				
				self.iconButton.image = nil
			}
		}
		
		// FIXME: 🐬 ここで読み込み済みの画像を使いまわしたり、同じ URL で読み込み中のものがあればそれを待つ処理を実装しないといけない。
		if let url = status.user.profile.imageUrlHttps.url {

			setImage(url)
		}
		else {

			resetImage()
		}
	}
}

extension TimelineTableCellView : TimelineTableCellType {

	static var prototypeCellIdentifier: String {
		
		return "TimelineCell"
	}

	static func makeCellWithItem(item: TimelineTableItem, tableView: NSTableView, owner: AnyObject?) -> NSTableCellView {
		
		let view = tweak(self.makeCellForTableView(tableView, owner: owner) as! TimelineTableCellView) {
			
			$0.textLabel.selectable = false
			$0.textLabel.allowsEditingTextAttributes = true
			
			$0.item = (item as! TimelineTweetItem)
		}
		
		return view
	}
	
	static func estimateCellHeightForItem(item:TimelineTableItem, tableView:NSTableView) -> CGFloat {

		let item = item as! TimelineTweetItem

		let baseHeight: CGFloat = 61
		let textLabelWidthAdjuster: CGFloat = 10.0

		let cell = self.getCellForEstimateHeightForTableView(tableView)
		
		cell.frame = tableView.rectOfColumn(0)

		let font = cell.textLabel.font
		let labelSize = item.status.text.sizeWithFont(font, lineBreakMode: .ByWordWrapping, maxWidth: cell.textLabel.bounds.width + textLabelWidthAdjuster)

		let textLabelHeight = cell.textLabel.bounds.height
		let estimateHeight = baseHeight + labelSize.height - textLabelHeight

		return estimateHeight
	}
	
	private static func getCellForEstimateHeightForTableView(tableView: NSTableView) -> TimelineTableCellView {
		
		if self.cellForEstimateHeight == nil {
			
//			let cell = self.makeCellForTableView(tableView, owner: self) as! TimelineTableCellView
			guard let topObjects = tableView.topObjectsInRegisteredNibByIdentifier(self.prototypeCellIdentifier) else {
			
				fatalError()
			}
			
			self.cellForEstimateHeight = topObjects.flatMap { $0 as? TimelineTableCellView } .first!
		}
		
		return self.cellForEstimateHeight
	}
}

extension TimelineTableCellView.Style {
	
	var backgroundColor:NSColor {

		switch self {

		case .Recent:
			return NSColor.whiteColor()
			
		case .Past:
			return NSColor(red: 0.94, green: 0.94, blue: 0.94, alpha: 1.0)
		}
	}
	
	var selectionBackgroundColor:NSColor {
		
		switch self {
			
		case .Recent:
			return NSColor(red: 0.858, green: 0.929, blue: 1.000, alpha: 1.0)
			
		case .Past:
			return NSColor(red: 0.858, green: 0.858, blue: 1.000, alpha: 1.0)
		}
	}
}