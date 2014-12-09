//
//  Score.m
//  swipe
//
//  Created by Michael Woo on 8/15/14.
//  Copyright (c) 2014 Michael Woo. All rights reserved.
//

#import "Score.h"

@implementation Score


static NSString* const ScoreDataOneDotKey = @"highScoreOneDot";
static NSString* const ScoreDataArrowKey = @"highScoreArrowKey";
static NSString* const ScoreDataRandomKey = @"highScoreRandom";


-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeInteger:self.highScore forKey:ScoreDataOneDotKey];
    [aCoder encodeInteger:self.highScoreArrow forKey:ScoreDataArrowKey];
    [aCoder encodeInteger:self.highScoreRandom forKey:ScoreDataRandomKey];
}

//NSCoding Protocal
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
 
    if (self =[self init]) {
        _highScore = [aDecoder decodeIntegerForKey:ScoreDataOneDotKey];
        _highScoreArrow = [aDecoder decodeIntegerForKey:ScoreDataArrowKey];
        _highScoreRandom = [aDecoder decodeIntegerForKey:ScoreDataRandomKey];
    }
    
    return self;
}

//Store Data in game
+(NSString*) filePath {
    static NSString* filePath = nil;
    if(!filePath){
        filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingString:@"gamedata"];
    }
    
    return filePath;
}
+(instancetype)loadInstance{
    NSData* decodedData = [NSData dataWithContentsOfFile:[Score filePath]];
    if(decodedData){
        Score* gameScore = [NSKeyedUnarchiver unarchiveObjectWithData:decodedData];
        return gameScore;
    }
    
    return [[Score alloc]init];
}
    
//Create singleton
+(instancetype)sharedGameData {
    
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [self loadInstance];
    });
    
    return sharedInstance;
}
-(void)save{
    NSData* encodeData = [NSKeyedArchiver archivedDataWithRootObject:self];
    [encodeData writeToFile:[Score filePath] atomically:YES];
}
-(void)reset{
    _currentScore = 0;
}



@end
