//
//  Dot.h
//  swipe
//
//  Created by Michael Woo on 8/14/14.
//  Copyright (c) 2014 Michael Woo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Dot : SKSpriteNode   

-(id)init;
-(void)spawnDot;
-(void)spawnArrow;
-(void)spawnRandom;


/*typedef NS_ENUM(int, swipeDirection){
    swipeDirectionUp = 0,
    swipeDirectionDown = 1,
    swipeDirectionLeft = 2,
    swipeDirectionRight = 3,
    
};*/



@end
