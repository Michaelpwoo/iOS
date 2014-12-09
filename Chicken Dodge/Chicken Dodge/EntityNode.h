//
//  EntityNode.h
//  Chicken Dodge
//
//  Created by Michael Woo on 6/17/14.
//  Copyright (c) 2014 Michael Woo. All rights reserved.
//
//  Used by subclass

#import <SpriteKit/SpriteKit.h>

typedef NS_ENUM(int, CollisionMask) {
    CollisionMaskPlayer = 0x1 << 0,
    CollisionMaskObstacle = 0x1 << 1
};

@interface EntityNode : SKSpriteNode

- (id)initWithPosition:(CGPoint)position;
- (void)configurePhysics;
- (void)update:(CFTimeInterval)currentTime;
@end
