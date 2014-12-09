//
//  PlayerNode.m
//  Chicken Dodge
//
//  Created by Michael Woo on 6/17/14.
//  Copyright (c) 2014 Michael Woo. All rights reserved.
//

#import "PlayerNode.h"
@import CoreMotion;

CMMotionManager *_motionManager;
double speedX;

@implementation PlayerNode

-(id)initWithPosition:(CGPoint)position{
    if(self = [super initWithPosition:position]){
        self = [PlayerNode spriteNodeWithImageNamed:@"Chicken"];
        self.name = @"Chicken";
        self.position = position;
        
        [self configurePhysics];
        // Initialize accelerometer
        _motionManager = [[CMMotionManager alloc] init];
        _motionManager.accelerometerUpdateInterval = 0.2;
        [_motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
            [self outputAccelerationData2:accelerometerData.acceleration];
            if (error) {
                NSLog(@"%@",error);
            }
        }];
    }
    
    return self;
}

// retrieve data from accelerometer
-(void) outputAccelerationData2:(CMAcceleration)acceleration{
    speedX = 0;
    
    if(fabs(acceleration.x) > fabs(speedX)){
        speedX = acceleration.x;
    }
    
    
}

// player movement using accelerometer
-(void) movePlayer {

    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    float newX = 0;
    //right
    if (speedX > 0.05) {
        newX = speedX * 20;
        self.zRotation = DegreesToRadians(25);
    }
    //left
    else if(speedX < -0.05){
        newX = speedX * 20;
        self.zRotation = DegreesToRadians(-25);
    }
    //noting
    else {
        newX = speedX *20;
        self.zRotation = DegreesToRadians(0);
    }
    if(self.position.x + newX < 0 || self.position.x +newX > width){
        return;
    }
    self.position = CGPointMake(newX+self.position.x, self.position.y);
}
//sets up the physics and frame of the player
- (void) configurePhysics{
    
    CGFloat offsetX = self.frame.size.width * self.anchorPoint.x;
    CGFloat offsetY = self.frame.size.height * self.anchorPoint.y;
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathMoveToPoint(path, NULL, 33 - offsetX, 7 - offsetY);
    CGPathAddLineToPoint(path, NULL, 43 - offsetX, 10 - offsetY);
    CGPathAddLineToPoint(path, NULL, 50 - offsetX, 16 - offsetY);
    CGPathAddLineToPoint(path, NULL, 53 - offsetX, 26 - offsetY);
    CGPathAddLineToPoint(path, NULL, 59 - offsetX, 30 - offsetY);
    CGPathAddLineToPoint(path, NULL, 52 - offsetX, 30 - offsetY);
    CGPathAddLineToPoint(path, NULL, 45 - offsetX, 39 - offsetY);
    CGPathAddLineToPoint(path, NULL, 36 - offsetX, 43 - offsetY);
    CGPathAddLineToPoint(path, NULL, 23 - offsetX, 43 - offsetY);
    CGPathAddLineToPoint(path, NULL, 12 - offsetX, 38 - offsetY);
    CGPathAddLineToPoint(path, NULL, 7 - offsetX, 32 - offsetY);
    CGPathAddLineToPoint(path, NULL, 0 - offsetX, 31 - offsetY);
    CGPathAddLineToPoint(path, NULL, 6 - offsetX, 28 - offsetY);
    CGPathAddLineToPoint(path, NULL, 7 - offsetX, 23 - offsetY);
    CGPathAddLineToPoint(path, NULL, 9 - offsetX, 17 - offsetY);
    CGPathAddLineToPoint(path, NULL, 16 - offsetX, 9 - offsetY);
    CGPathAddLineToPoint(path, NULL, 24 - offsetX, 7 - offsetY);
    
    CGPathCloseSubpath(path);
    
    self.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:path];
    
    self.physicsBody.categoryBitMask = CollisionMaskPlayer;
    self.physicsBody.collisionBitMask = 0;
    self.physicsBody.contactTestBitMask = CollisionMaskObstacle;
}

// Called every frame during game play
-(void)update:(CFTimeInterval)currentTime{
    [self movePlayer];
}

@end
