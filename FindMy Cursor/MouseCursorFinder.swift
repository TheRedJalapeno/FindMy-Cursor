import Cocoa

class MouseCursorFinder {
    static let shared = MouseCursorFinder()

    private var mouseClickCount = 0
    private var timer: Timer?

    private init() {}

    func start() {
        NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseDown], handler: handleEvent)
        NSEvent.addLocalMonitorForEvents(matching: [.leftMouseDown], handler: { event in
            self.handleEvent(event)
            return event
        })
    }

    private func handleEvent(_ event: NSEvent) {
        switch event.type {
        case .leftMouseDown:
            mouseClickCount += 1
            resetCountsAfterDelay()
            if mouseClickCount == 8 {
                mouseClickCount = 0
                showShrinkingSquare()
            }
        default:
            break
        }
    }

    private func resetCountsAfterDelay() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
            self.mouseClickCount = 0
        }
    }

    private func showShrinkingSquare() {
        guard let screen = NSScreen.main else { return }
        let cursorLocation = NSEvent.mouseLocation
        let initialLength: CGFloat = 200
        let duration: TimeInterval = 3

        // Calculate the correct Y position
        let yPos = cursorLocation.y - initialLength / 2

        let overlayWindow = NSWindow(
            contentRect: screen.frame,
            styleMask: [.borderless],
            backing: .buffered, defer: false)
        overlayWindow.isOpaque = false
        overlayWindow.backgroundColor = NSColor.clear
        overlayWindow.level = .floating
        overlayWindow.ignoresMouseEvents = true
        overlayWindow.collectionBehavior = [.canJoinAllSpaces, .ignoresCycle]

        let square = NSView(frame: CGRect(x: cursorLocation.x - initialLength / 2, y: yPos, width: initialLength, height: initialLength))
        square.wantsLayer = true
        square.layer?.borderColor = NSColor.red.cgColor
        square.layer?.borderWidth = 3
        square.layer?.backgroundColor = NSColor.clear.cgColor

        overlayWindow.contentView?.addSubview(square)
        overlayWindow.orderFrontRegardless()

        NSAnimationContext.runAnimationGroup({ context in
            context.duration = duration
            square.animator().frame = CGRect(x: cursorLocation.x, y: yPos + initialLength / 2, width: 0, height: 0)
        }) {
            overlayWindow.orderOut(nil)
        }
    }
}
