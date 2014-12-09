//
//  Timer.m
//  swipe
//
//  Created by AdminHJI on 8/14/14.
//  Copyright (c) 2014 Michael Woo. All rights reserved.
//

#import "Timer.h"

@implementation Timer{
    double startTime;
    double totalTime;
    BOOL startGame;
    double timeLeft;
}

//Init the timer with font and timer
-(id)initWithFontNamed:(NSString *)fontName andTime:(double)time{
    
    if(self = [super init]){
        
        self.fontName = fontName;
        self.fontColor = [SKColor blackColor];
        self.text = [NSString stringWithFormat:@"%.2f",time];
        totalTime = time;
        self.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
        startGame = YES;
    }
    
    return self;
}

//Start the countdown
-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */

    if(startGame){
        startTime = currentTime;
        startGame = NO;
    }
    timeLeft= (double)totalTime - (currentTime - startTime);

    self.text = [NSString stringWithFormat:@"%02.2f", timeLeft];
    if(timeLeft <= 0){
        totalTime = 0.00;
        self.text = [NSString stringWithFormat:@"%02.2f", totalTime];
        return;

    }
}

//Stop time
-(double)getTimeLeft{
    if(timeLeft< 0.00){
        timeLeft = 0;
    }
    return timeLeft;
}

//Add time to the timer
-(void)addTime:(double)add{
    totalTime += add;
}
-(BOOL)isOutOfTime{
    if(totalTime <= 0.00){
        return YES;
    } else {
        return NO;
    }
}
@end
