//
//  GroundNode.m
//  Chicken Dodge
//
//  Created by Michael Woo on 6/17/14.
//  Copyright (c) 2014 Michael Woo. All rights reserved.
//

#import "GroundNode.h"

@implementation GroundNode

-(id)initWithPosition:(CGPoint)position{
    if (self = [super initWithPosition:position]) {
        self = [GroundNode spriteNodeWithImageNamed:@"Grass"];
        self.position = position;
        [self configurePhysics];
    }
    return self;
}


- (void)update:(CFTimeInterval)currentTime{
    
}
- (void)configurePhysics{
 
    self.anchorPoint = CGPointMake(1, 0);
    
    // physics
    CGFloat offsetX = self.frame.size.width * self.anchorPoint.x;
    CGFloat offsetY = self.frame.size.height * self.anchorPoint.y;
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathMoveToPoint(path, NULL, 393 - offsetX, 5 - offsetY);
    CGPathAddLineToPoint(path, NULL, 393 - offsetX, 54 - offsetY);
    CGPathAddLineToPoint(path, NULL, 389 - offsetX, 59 - offsetY);
    CGPathAddLineToPoint(path, NULL, 2 - offsetX, 59 - offsetY);
    CGPathAddLineToPoint(path, NULL, 0 - offsetX, 56 - offsetY);
    CGPathAddLineToPoint(path, NULL, 0 - offsetX, 5 - offsetY);
    CGPathAddLineToPoint(path, NULL, 7 - offsetX, 0 - offsetY);
    CGPathAddLineToPoint(path, NULL, 388 - offsetX, 0 - offsetY);
    
    CGPathCloseSubpath(path);
    
    self.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:path];
    
    
    self.physicsBody.categoryBitMask = CollisionMaskObstacle;
    self.physicsBody.collisionBitMask = 0;
    self.physicsBody.contactTestBitMask = CollisionMaskPlayer;
}


@end
