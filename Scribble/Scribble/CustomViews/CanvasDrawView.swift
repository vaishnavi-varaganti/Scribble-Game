 
import SwiftUI
import PencilKit

struct CanvasDrawView: UIViewRepresentable {
    class Coordinator: NSObject, PKCanvasViewDelegate {
        var matchManager: ScriblleGameManager
        
        init(matchManager: ScriblleGameManager) {
            self.matchManager = matchManager
        }
        
        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            guard canvasView.isUserInteractionEnabled else { return }
            matchManager.sendData(canvasView.drawing.dataRepresentation(), mode: .reliable)
        }
    }
    
    @ObservedObject var matchManager: ScriblleGameManager
    @Binding var eraserEnabled: Bool
    
    func makeUIView(context: Context) -> PKCanvasView {
        let canvasView = PKCanvasView()
        
        canvasView.drawingPolicy = .anyInput
        canvasView.tool = PKInkingTool(.pen, color: .black, width: 5)
        canvasView.delegate = context.coordinator
        canvasView.isUserInteractionEnabled = matchManager.currentlyDrawing
        
        return canvasView
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(matchManager: matchManager)
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        let wasDrawing = uiView.isUserInteractionEnabled
        uiView.isUserInteractionEnabled = matchManager.currentlyDrawing
        if !wasDrawing && matchManager.currentlyDrawing {
            uiView.drawing = PKDrawing()
        }
        
        if !uiView.isUserInteractionEnabled || !matchManager.inGame {
            uiView.drawing = matchManager.lastReceivedDrawing
        }
        
        uiView.tool = eraserEnabled ? PKEraserTool(.vector) : PKInkingTool(.pen, color: .black, width: 5)
    }
}

 
