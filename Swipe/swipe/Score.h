//
//  Score.h
//  swipe
//
//  Created by Michael Woo on 8/15/14.
//  Copyright (c) 2014 Michael Woo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Score : NSObject <NSCoding>

@property(assign, nonatomic) int currentScore;
@property(assign, nonatomic) int highScore;
@property(assign, nonatomic) int highScoreArrow;
@property(assign, nonatomic) int highScoreRandom;


+(instancetype)sharedGameData;
-(void)reset;
-(void)save;

@end
