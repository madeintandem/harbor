import Foundation

extension Ui {
  struct Loading {
    private static let frames = [".  ", ".. ", "...", "   "]
    private static var frame = 0
    private static var isRunning = false

    static func start() {
      isRunning = true
      inline("\u{001B}[?25l")
      rerender()
    }

    static func stop() {
      inline("\u{001B}[?25h")
      isRunning = false
    }

    // repeating
    private static func schedule() {
      let delta = DispatchTime.now() + 0.2
      DispatchQueue.main.asyncAfter(deadline: delta) {
        frame = (frame + 1) % frames.count
        self.rerender()
      }
    }

    private static func rerender() {
      if isRunning {
        self.render()
        self.clear()
        self.schedule()
      }
    }

    // rendering
    private static func render() {
      inline(frames[frame])
    }

    private static func clear() {
      inline("\u{001B}[\(frames.count)D")
    }
  }
}
