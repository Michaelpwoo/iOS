//
//  Dot.m
//  swipe
//
//  Created by Michael Woo on 8/14/14.
//  Copyright (c) 2014 Michael Woo. All rights reserved.
//

#import "Dot.h"

static NSString *const kFont = @"AppleSDGothicNeo-Thin";


//swipeDirection swipe;

@implementation Dot{
    
    NSArray *swipeArray;
    int randIndex;
}

//Init the dot
-(id)init{
    
    if (self = [super init]) {
        self.name = @"dot";
        [self setupSwipeArray];
        
    }
    
    return self;
}

//Initilize the array that will hold the data for the swipe
-(void) setupSwipeArray{
    
    //0. Direction 1. Color 2. Identifier
    swipeArray = @[
                   @[@"up",@"green", @"directionUp"],
                   @[@"down",@"green", @"directionDown"],
                   @[@"left",@"green", @"directionLeft"],
                   @[@"right",@"green", @"directionRight"],
                   @[@"up", @"red", @"directionDown"],
                   @[@"down",@"red", @"directionUp"],
                   @[@"left",@"red",@"directionRight"],
                   @[@"right",@"red",@"directionLeft"],
                   
                   @[@"up",@"arrowgreen", @"directionUp"],
                   @[@"down",@"arrowgreen", @"directionDown"],
                   @[@"left",@"arrowgreen", @"directionLeft"],
                   @[@"right",@"arrowgreen", @"directionRight"],
                   @[@"up", @"arrowred", @"directionDown"],
                   @[@"down",@"arrowred", @"directionUp"],
                   @[@"right",@"arrowred",@"directionRight"],
                   @[@"left",@"arrowred",@"directionLeft"],
                   ];

}

-(void)spawnDot{
    //Create random dot (red or green) and add it to the worldNode
    randIndex = arc4random() % 8;
    SKSpriteNode *dot = [SKSpriteNode spriteNodeWithImageNamed:swipeArray[randIndex][1]];
    dot.name = swipeArray[randIndex][2];
    [self addChild:dot];
    
    //Get the string in the swipe array and add it to the worldNode
    SKLabelNode *direction = [SKLabelNode labelNodeWithFontNamed:kFont];
    direction.fontSize = 30;
    direction.name = swipeArray[randIndex][2];
    direction.text = swipeArray[randIndex][0];
    direction.userInteractionEnabled = NO;
    NSLog(@"Direction: %@ Color: %@",swipeArray[randIndex][2],swipeArray[randIndex][1]);
    direction.position = CGPointMake(0, -10);
    [dot addChild: direction];
}

-(void)spawnArrow{
    randIndex = arc4random() % 8 + 8;
    SKSpriteNode *dot = [SKSpriteNode spriteNodeWithImageNamed:swipeArray[randIndex][1]];
    dot.name = swipeArray[randIndex][2];
    NSString *direction = swipeArray[randIndex][2];
    NSString *color = swipeArray[randIndex][1];
    if ([direction isEqualToString:@"directionUp"] && [color isEqualToString:@"arrowgreen"]) {
        dot.zRotation = DegreesToRadians(90.00);
    } else if ([direction isEqualToString:@"directionUp" ] && [color isEqualToString:@"arrowred"]) {
        dot.zRotation = DegreesToRadians(-90.00);
    } else if ([direction isEqualToString:@"directionDown" ] && [color isEqualToString:@"arrowgreen"]) {
        dot.zRotation = DegreesToRadians(-90.00);
    } else if ([direction isEqualToString:@"directionDown" ] && [color isEqualToString:@"arrowred"]) {
        dot.zRotation = DegreesToRadians(90.00);
    } else if ([direction isEqualToString:@"directionLeft" ] && [color isEqualToString:@"arrowgreen"]) {
        dot.zRotation = DegreesToRadians(180.00);
    } else if ([direction isEqualToString:@"directionRight" ] && [color isEqualToString:@"arrowred"]) {
        dot.zRotation = DegreesToRadians(-180.00);
    }
    
    
    [self addChild:dot];
}

-(void)spawnRandom{
    randIndex = arc4random() % 2;
    if (randIndex == 0) {
        [self spawnDot];
    } else {
        [self spawnArrow];
    }

}
//Helper function to  rotate arrow
CGFloat RadiansToDegrees(CGFloat radians) {
    return radians * 180.0 / M_PI;
}
CGFloat DegreesToRadians(CGFloat degrees) {
    return M_PI * degrees / 180.0;
}
@end
