//
//  Conductor.h
//  Space Cannon
//
//  Created by Aurelius Prochazka on 11/8/14.
//  Copyright (c) 2014 Hear For Yourself. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Conductor : NSObject

- (instancetype)initWithPlayfieldSize:(CGSize)size;

// Halo Lifespan Events
- (void)haloSpawnedAtPosition:(CGPoint)position isMultiplier:(bool)isMultiplier;
- (void)haloHitEdgeAtPosition:(CGPoint)position;
- (void)haloHitBallAtPosition:(CGPoint)position forPoints:(int)points;
- (void)haloHitShieldAtPosition:(CGPoint)position;
- (void)haloHitLifeBar;

// Shield Power Up Events
- (void)spawnedShieldPowerUpAtPosition:(CGPoint)position;
- (void)replacedShieldAtPosition:(CGPoint)position;

// Player Events
- (void)playerShotBallWithRotationVector:(CGVector)rotationVector
                            remaningAmmo:(int)remainingAmmo;
- (void)attemptedShotWithoutAmmo;
- (void)ballBouncedAtPosition:(CGPoint)position;
- (void)multiplierModeStartedWithPointValue:(int)points;
- (void)multiplierModeEnded;



@end
