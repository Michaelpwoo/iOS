//
//  GameScore.m
//  Chicken Dodge
//
//  Created by Michael Woo on 6/19/14.
//  Copyright (c) 2014 Michael Woo. All rights reserved.
//

#import "GameScore.h"

@implementation GameScore

// create singleton
+(instancetype)shared{
    
    static dispatch_once_t pred = 0;
    static GameScore *_shared = nil;
    
    dispatch_once (&pred, ^{ _shared = [[super alloc] init];});
    
    return _shared;
        
}


-(id)init{
    
    if(self = [super init]){
        _highScore = 0;
        _score = 0;
        
        // load setting
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        id hightScore = [defaults objectForKey:@"HightScore"];
        if(hightScore){
            _highScore = [hightScore intValue];
        }
    }
    
    return  self;
}
// save high score
-(void) saveGame{
   
    _highScore = MAX(_highScore, _score);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithInt:_highScore] forKey:@"HightScore"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

-(void) scoreReset{
    _score = 0;
}

@end
