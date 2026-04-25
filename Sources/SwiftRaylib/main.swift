import raylib

@main
struct SwiftRaylib {
    static func main() {
        let screenWidth: Int32 = 800
        let screenHeight: Int32 = 600
        InitWindow(screenWidth, screenHeight, "Swift + Raylib")
        SetTargetFPS(60)

        var boxPos = Vector2(x: 100, y: 100)
        var boxVel = Vector2(x: 4, y: 3)
        let boxSize: Float = 60

        while !WindowShouldClose() {
            // Update
            boxPos.x += boxVel.x
            boxPos.y += boxVel.y
            if boxPos.x <= 0 || boxPos.x + boxSize >= Float(screenWidth) {
                boxVel.x = -boxVel.x
                boxPos.x = max(0, min(boxPos.x, Float(screenWidth) - boxSize))
            }
            if boxPos.y <= 0 || boxPos.y + boxSize >= Float(screenHeight) {
                boxVel.y = -boxVel.y
                boxPos.y = max(0, min(boxPos.y, Float(screenHeight) - boxSize))
            }

            // Draw
            BeginDrawing()
            ClearBackground(Color(r: 24, g: 24, b: 32, a: 255))
            DrawRectangleV(
                boxPos,
                Vector2(x: boxSize, y: boxSize),
                Color(r: 230, g: 90, b: 120, a: 255)
            )
            DrawText(
                "Hello, raylib from Swift!", 20, 20, 20,
                Color(r: 240, g: 240, b: 240, a: 255))
            DrawFPS(screenWidth - 90, 10)
            EndDrawing()
        }
        CloseWindow()
    }
}
