//
//  Timer.h
//  swipe
//
//  Created by AdminHJI on 8/14/14.
//  Copyright (c) 2014 Michael Woo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Timer : SKLabelNode

//Create the timer
-(id)initWithFontNamed:(NSString *)fontName andTime:(double)timer;
//Method is called everything frame
-(void)update:(NSTimeInterval)currentTime;
//Add time to the timer
-(void)addTime:(double)add;
//Check if timer has reached 0.00
-(BOOL)isOutOfTime;
//Return remaining time
-(double)getTimeLeft;

@end
