//
//  ImmersiveView.swift
//  Bubbles
//
//  Created by Riana Santos on 4/20/25.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ImmersiveView: View {
    @State var predicate = QueryPredicate<Entity>.has(ModelComponent.self)
    @State private var timer: Timer?
    @State private var bubble = Entity()
    var body: some View {
        RealityView { content in
            // Add the initial RealityKit content
            if let scene = try? await Entity(named: "BubbleScene", in: realityKitContentBundle) {
                bubble = scene.findEntity(named: "Bubble")!
                for _ in 1...20{
                    var bubbleClone = bubble.clone(recursive: true)
                    let x = Float.random(in: -1.5...1.5)
                    let y = Float.random(in: 1...1.5)
                    let z = Float.random(in: -1.5...1.5)
                    bubbleClone.position = [x, y, z]
                    content.add(bubbleClone)
                }
            }
        }
        .gesture(SpatialTapGesture().targetedToEntity(where: predicate).onEnded({
            value in
            let entity = value.entity
            var mat = entity.components[ModelComponent.self]?.materials.first as! ShaderGraphMaterial
            let frameRate: TimeInterval = 1.0/60.0
            let duration: TimeInterval = 0.25
            let targetValue: Float = 1
            let totalFrames = Int(duration / frameRate)
            var currentFrame = 0
            var popValue: Float = 0
            timer?.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: frameRate, repeats: true, block: { timer in
                currentFrame += 1
                let progress = Float(currentFrame) / Float(totalFrames)
                popValue = progress * targetValue
                do{
                    try mat.setParameter(name: "Pop", value: .float(popValue))
                    entity.components[ModelComponent.self]?.materials = [mat]
                }
                catch{
                    print(error.localizedDescription)
                }
                if currentFrame >= totalFrames{
                    timer.invalidate()
                    entity.removeFromParent()
                }
            })
        }))
    }
}

#Preview {
    ImmersiveView()
        .previewLayout(.sizeThatFits)
}
