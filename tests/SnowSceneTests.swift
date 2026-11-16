import Cocoa
import SpriteKit

@main
struct SnowSceneTests {
    @MainActor static func expect(_ condition: @autoclosure () -> Bool, _ message: String) {
        guard condition() else {
            fputs("FAIL: \(message)\n", stderr)
            exit(1)
        }
    }

    @MainActor static func makeScene() -> SnowScene {
        let scene = SnowScene(size: CGSize(width: 1440, height: 900))
        scene.tex = SKTexture(image: NSImage(size: NSSize(width: 8, height: 8)))
        scene.resetGround()
        return scene
    }

    @MainActor static func addFlake(to scene: SnowScene) -> Flake {
        scene.spawnFlake(y: 901)
        let flake = scene.flakes.last!
        flake.node.position.x = 720
        flake.vel = CGVector(dx: 0, dy: -100)
        flake.windFactor = 0
        flake.swayAmp = 0
        flake.inFront = false
        flake.foregroundCandidate = false
        return flake
    }

    @MainActor static func main() {
        _ = NSApplication.shared
        Cfg.targetFlakes = 0
        let fullScreen = CGRect(x: 0, y: 0, width: 1440, height: 900)
        let dialog = CGRect(x: 400, y: 200, width: 400, height: 200)
        let normal = CGRect(x: 100, y: 100, width: 1000, height: 600)
        let maximized = CGRect(x: 0, y: 90, width: 1440, height: 780)

        // Finder window-server snapshot: a 52-point toolbar precedes its full-screen frame.
        // Also cover taller auto-hiding toolbars and menu/camera-reserved top bands.
        for (inset, toolbarHeight) in [(CGFloat(0), CGFloat(52)), (0, 96), (30, 52), (38, 96)] {
            let top = 900 - inset
            let toolbar = CGRect(x: 0, y: top - toolbarHeight, width: 1440, height: toolbarHeight)
            let frame = CGRect(x: 0, y: 0, width: 1440, height: top)
            for accumulation in [true, false] {
                for allSizes in [true, false] {
                    let scene = makeScene()
                    scene.setAccumulationEnabled(accumulation)
                    scene.allFlakeSizesOverWindows = allSizes
                    scene.syncWindows([(id: 1, rect: toolbar), (id: 2, rect: frame)], dt: 1 / 30, topInset: inset)
                    scene.computeOcclusion()
                    expect(scene.order.isEmpty && scene.piles.isEmpty, "Full-screen toolbar must not survive as a snow obstacle")
                    let flake = addFlake(to: scene)
                    for _ in 0..<90 { scene.stepFlakes(1 / 60) }
                    expect(scene.flakes.count == 1 && scene.flakes[0] === flake, "Flake must not be recycled at the toolbar")
                    expect(abs(flake.node.position.y - 751) < 0.05 && flake.node.position.x == 720, "Flake must move continuously through the top band")
                }
            }
        }

        let scene = makeScene()
        let toolbar = CGRect(x: 0, y: 848, width: 1440, height: 52)
        let cornerControls = CGRect(x: 0, y: 860, width: 100, height: 40)
        scene.syncWindows([(id: 10, rect: normal)], dt: 1 / 30)
        scene.piles[10]!.add(at: 20, amount: 12)
        scene.syncWindows([
            (id: 1, rect: dialog), (id: 2, rect: cornerControls), (id: 3, rect: toolbar),
            (id: 4, rect: fullScreen), (id: 5, rect: normal)
        ], dt: 1 / 30)
        expect(scene.order.map(\.id) == [1] && scene.piles.count == 1, "Keep exposed floating dialogs, excluding edge controls and covered windows")
        expect(scene.flakes.isEmpty, "Full-screen transitions must not fling hidden window piles")
        for _ in 0..<10 {
            scene.syncWindows([(id: 3, rect: toolbar), (id: 4, rect: fullScreen)], dt: 1 / 30)
            scene.syncWindows([(id: 4, rect: fullScreen)], dt: 1 / 30)
        }
        expect(scene.order.isEmpty && scene.piles.isEmpty && scene.flakes.isEmpty, "Showing/hiding a full-screen toolbar must not create snow bursts")

        for frame in [normal, maximized] {
            scene.syncWindows([(id: 10, rect: frame)], dt: 1 / 30, topInset: 30)
            expect(scene.order.map(\.id) == [10] && scene.piles[10] != nil, "Normal and maximized windows must still collect snow")
        }
        scene.syncWindows([(id: 10, rect: normal)], dt: 1 / 30)
        scene.piles[10]!.add(at: 20, amount: 12)
        scene.syncWindows([(id: 10, rect: normal.offsetBy(dx: 20, dy: 0))], dt: 1 / 30)
        expect(scene.flakes.contains { $0.isClump }, "Dragging a normal window must still fling snow")
        print("PASS: full-screen toolbars, menu/camera bands, flake continuity, dialogs, toolbar visibility, normal windows and dragging")
    }
}
