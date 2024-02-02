//
//  ViewController.swift
//  Repo Card Generator
//
//  Created by Cocoa on 01/02/2024.
//

import Cocoa
import UniformTypeIdentifiers

class ViewController: NSViewController {
  @IBOutlet weak var templateView: RCGTemplateView!
  @IBOutlet weak var iconImageView: NSImageView!
  @IBOutlet weak var titleTextField: NSTextField!
  @IBOutlet weak var subtitleTextField: NSTextField!
  var titleFont = NSFont(name: "FiraCode Nerd Font Mono", size: 30.0)
  var subtitleFont = NSFont(name: "FiraCode Nerd Font Mono", size: 20.0)
  override func viewDidLoad() {
    super.viewDidLoad()
    self.iconImageView.focusRingType = .none
    self.iconImageView.imageScaling = .scaleProportionallyUpOrDown
    self.titleTextField.font = self.titleFont
    self.titleTextField.focusRingType = .none
    self.titleTextField.isEditable = true
    self.titleTextField.setNeedsDisplay(self.titleTextField.frame)
    self.subtitleTextField.font = self.subtitleFont
    self.subtitleTextField.focusRingType = .none
    self.subtitleTextField.isEditable = true
    self.subtitleTextField.setNeedsDisplay(self.subtitleTextField.frame)
  }
  
  override func mouseDown(with theEvent: NSEvent) {
    self.view.window?.makeFirstResponder(self.view)
  }
  
  func togglePreview() {
    self.view.window?.makeFirstResponder(self.view)
    self.templateView.showOverlay = !self.templateView.showOverlay
    self.updateTextFieldStatus()
  }
  
  func updateTextFieldStatus() {
    if self.templateView.showOverlay {
      self.titleTextField.placeholderString = "Title"
      self.subtitleTextField.placeholderString = "Subtitle"
    } else {
      if self.titleTextField.stringValue.isEmpty {
        self.titleTextField.placeholderString = ""
      }
      if self.subtitleTextField.stringValue.isEmpty {
        self.subtitleTextField.placeholderString = ""
      }
    }
  }
  
  func saveRepoCard() {
    self.view.window?.makeFirstResponder(self.view)
    let savedShowOverlay = self.templateView.showOverlay
    self.templateView.showOverlay = false
    self.updateTextFieldStatus()
    
    let rep = self.view.bitmapImageRepForCachingDisplay(in: self.view.bounds)!
    self.view.cacheDisplay(in: self.view.bounds, to: rep)
    
    if let data = rep.representation(using: .png, properties: [:]) {
      let savePanel = buildRepoCardSavePanel()
      savePanel.beginSheetModal(for: self.view.window!) { (result: NSApplication.ModalResponse) in
        if result == NSApplication.ModalResponse.OK {
          if let panelURL = savePanel.url {
            do {
              try data.write(to: panelURL, options: .atomic)
            } catch {
              self.templateView.showOverlay = savedShowOverlay
              self.updateTextFieldStatus()
            }
          }
        } else {
          self.templateView.showOverlay = savedShowOverlay
          self.updateTextFieldStatus()
        }
      }
    } else {
      self.templateView.showOverlay = savedShowOverlay
      self.updateTextFieldStatus()
    }
  }
  
  func buildRepoCardSavePanel() -> NSSavePanel {
    let savePanel = NSSavePanel()
    savePanel.title = "Repo Card"
    savePanel.nameFieldLabel = "Filename:"
    let defaultTitle = self.titleTextField.stringValue
    savePanel.nameFieldStringValue = defaultTitle.isEmpty ? "repo-graph-card" : defaultTitle
    savePanel.prompt = "Save Repo Card"
    savePanel.allowedContentTypes = [.png]
    return savePanel
  }
}

class RCGTemplateView: NSView {
  var overlay: RCGBorderLineOverlay!
  var showOverlay: Bool! = true {
    didSet {
      self.overlay.show = self.showOverlay
    }
  }
  
  override init(frame frameRect: NSRect) {
    super.init(frame: frameRect)
    setupTemplateView()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupTemplateView()
  }
  
  func setupTemplateView() {
    self.overlay = RCGBorderLineOverlay.init(frame: self.frame)
    self.addSubview(overlay)
    self.wantsLayer = true
    self.layer?.backgroundColor = NSColor.white.cgColor
  }
}

class RCGBorderLineOverlay: NSView {
  override init(frame frameRect: NSRect) {
    super.init(frame: frameRect)
    setupOverlay()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupOverlay()
  }
  
  func setupOverlay() {
    self.show = true
    self.wantsLayer = true
    self.layer?.backgroundColor = NSColor.clear.cgColor
  }
  
  var show: Bool! = false {
    didSet {
      setNeedsDisplay(self.frame)
    }
  }
  
  var margin: CGFloat! = 40.0 {
    didSet {
      setNeedsDisplay(self.frame)
    }
  }
  
  override func draw(_ dirtyRect: NSRect) {
    if !self.show { return }
    
    let color = NSColor(red: 1, green: 0.933, blue: 0.941, alpha: 1)
    let color2 = NSColor(red: 0.69, green: 0.118, blue: 0.176, alpha: 1)

    let rectanglePath = NSBezierPath(rect: NSRect(x: 0, y: dirtyRect.height - self.margin, width: dirtyRect.width, height: self.margin))
    color.setFill()
    rectanglePath.fill()
    
    let rectangle2Path = NSBezierPath(rect: NSRect(x: 0, y: 0, width: dirtyRect.width, height: self.margin))
    color.setFill()
    rectangle2Path.fill()

    let rectangle3Path = NSBezierPath(rect: NSRect(x: 0, y: 0, width: self.margin, height: dirtyRect.height))
    color.setFill()
    rectangle3Path.fill()

    let rectangle4Path = NSBezierPath(rect: NSRect(x: dirtyRect.width - self.margin, y: 0, width: self.margin, height: dirtyRect.height))
    color.setFill()
    rectangle4Path.fill()

    let bezierPath = NSBezierPath()
    bezierPath.move(to: NSPoint(x: dirtyRect.width, y: dirtyRect.height - self.margin))
    bezierPath.line(to: NSPoint(x: 0, y: dirtyRect.height - self.margin))
    color2.setStroke()
    bezierPath.lineWidth = 1
    bezierPath.stroke()

    let bezier2Path = NSBezierPath()
    bezier2Path.move(to: NSPoint(x: dirtyRect.width, y: self.margin))
    bezier2Path.line(to: NSPoint(x: 0, y: self.margin))
    color2.setStroke()
    bezier2Path.lineWidth = 1
    bezier2Path.stroke()

    let bezier3Path = NSBezierPath()
    bezier3Path.move(to: NSPoint(x: self.margin, y: 0))
    bezier3Path.line(to: NSPoint(x: self.margin, y: dirtyRect.height))
    color2.setStroke()
    bezier3Path.lineWidth = 1
    bezier3Path.stroke()

    let bezier4Path = NSBezierPath()
    bezier4Path.move(to: NSPoint(x: dirtyRect.width - self.margin, y: 0))
    bezier4Path.line(to: NSPoint(x: dirtyRect.width - self.margin, y: dirtyRect.height))
    color2.setStroke()
    bezier4Path.lineWidth = 1
    bezier4Path.stroke()
  }
}

class RCGTextFieldCell: NSTextFieldCell {
  func adjustedFrame(toVerticallyCenterText rect: NSRect) -> NSRect {
    var titleRect = super.titleRect(forBounds: rect)

    let minimumHeight = self.cellSize(forBounds: rect).height
    titleRect.origin.y += (titleRect.height - minimumHeight) / 2
    titleRect.size.height = minimumHeight

    return titleRect
  }

  override func edit(withFrame rect: NSRect, in controlView: NSView, editor textObj: NSText, delegate: Any?, event: NSEvent?) {
    super.edit(withFrame: adjustedFrame(toVerticallyCenterText: rect), in: controlView, editor: textObj, delegate: delegate, event: event)
  }

  override func select(withFrame rect: NSRect, in controlView: NSView, editor textObj: NSText, delegate: Any?, start selStart: Int, length selLength: Int) {
    super.select(withFrame: adjustedFrame(toVerticallyCenterText: rect), in: controlView, editor: textObj, delegate: delegate, start: selStart, length: selLength)
  }

  override func drawInterior(withFrame cellFrame: NSRect, in controlView: NSView) {
    super.drawInterior(withFrame: adjustedFrame(toVerticallyCenterText: cellFrame), in: controlView)
  }

  override func draw(withFrame cellFrame: NSRect, in controlView: NSView) {
    super.draw(withFrame: cellFrame, in: controlView)
  }
  
  override var acceptsFirstResponder: Bool {
    get {
      return false
    }
  }
}
