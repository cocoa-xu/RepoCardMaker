//
//  AppDelegate.swift
//  Repo Card Generator
//
//  Created by Cocoa on 01/02/2024.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
  var mainWindow: NSWindow!
  
  @IBAction func togglePreview(_ sender: Any) {
    let vc = mainWindow.contentViewController as! ViewController
    vc.togglePreview()
  }
  
  @IBAction func saveRepoCard(_ sender: Any) {
    let vc = mainWindow.contentViewController as! ViewController
    vc.saveRepoCard()
  }
  
  func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
    if !flag{
      mainWindow.makeKeyAndOrderFront(nil)
    }
    return true
  }
  
  func applicationDidFinishLaunching(_ aNotification: Notification) {
    mainWindow = NSApplication.shared.windows[0]
    mainWindow.makeKeyAndOrderFront(nil)
  }

  func applicationWillTerminate(_ aNotification: Notification) {
    // Insert code here to tear down your application
  }

  func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
    return true
  }
}
