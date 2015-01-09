//
//  Conductor.m
//  Space Cannon
//
//  Created by Aurelius Prochazka and Nick Arner on 11/8/14.
//  Copyright (c) 2014 AudioKit. All rights reserved.
//

#import "Conductor.h"

#import "AKFoundation.h"

#import "SoftBoingInstrument.h"
#import "CrunchInstrument.h"
#import "PluckyInstrument.h"
#import "LaserInstrument.h"
#import "ZwoopInstrument.h"
#import "SirenInstrument.h"
#import "SpaceVerb.h"

@implementation Conductor
{
    SoftBoingInstrument *softBoingInstrument;
    CrunchInstrument *crunchInstrument;
    PluckyInstrument *pluckyInstrument;
    LaserInstrument *laserInstrument;
    ZwoopInstrument *zwoopInstrument;
    SirenInstrument *sirenInstrument;
    SpaceVerb *spaceVerb;
    
    CGSize playFieldSize;
}

- (instancetype)initWithPlayfieldSize:(CGSize)size
{
    self = [super init];
    if (self) {
        playFieldSize = size;
        
        softBoingInstrument = [[SoftBoingInstrument alloc] init];
        [AKOrchestra addInstrument:softBoingInstrument];
        
        crunchInstrument = [[CrunchInstrument alloc] init];
        [AKOrchestra addInstrument:crunchInstrument];
        
        pluckyInstrument = [[PluckyInstrument alloc] init];
        [AKOrchestra addInstrument:pluckyInstrument];
         
        laserInstrument = [[LaserInstrument alloc] init];
        [AKOrchestra addInstrument:laserInstrument];
        
        zwoopInstrument = [[ZwoopInstrument alloc] init];
        [AKOrchestra addInstrument:zwoopInstrument];
        
        sirenInstrument = [[SirenInstrument alloc]init];
        [AKOrchestra addInstrument:sirenInstrument];
        
        spaceVerb = [[SpaceVerb alloc] initWithSoftBoing:softBoingInstrument.auxilliaryOutput
                                                  crunch:crunchInstrument.auxilliaryOutput
                                                   pluck:pluckyInstrument.auxilliaryOutput
                                                   laser:laserInstrument.auxilliaryOutput
                                                   zwoop:zwoopInstrument.auxilliaryOutput
                                                   siren:sirenInstrument.auxilliaryOutput];
        [AKOrchestra addInstrument:spaceVerb];
        
        [AKOrchestra start];
        [spaceVerb play];
    }
    
    return self;
}

- (void)resetAll
{
    [sirenInstrument stop];
}

// -----------------------------------------------------------------------------
#  pragma mark - Halo Lifespan Events
// -----------------------------------------------------------------------------

- (void)haloHitEdgeAtPosition:(CGPoint)position
{
    float pan  = position.x / playFieldSize.width * 2.0 - 1.0;
    float fractionalHeight = (playFieldSize.height - position.y) / playFieldSize.height;
    
    Pluck  *newPluck = [[Pluck alloc] init]; //WithFrequency:frequency pan:pan];
    newPluck.frequency.value = newPluck.frequency.minimum + fractionalHeight * (newPluck.frequency.maximum - newPluck.frequency.minimum);
    newPluck.pan.value = pan;
    [pluckyInstrument playNote:newPluck];
}

- (void)haloHitBallAtPosition:(CGPoint)position
{
    float pan  = position.x / playFieldSize.width * 2.0 - 1.0;
    float fractionalHeight = (playFieldSize.height - position.y) / playFieldSize.height;
    
    Crunch *crunch = [[Crunch alloc] init];
    crunch.damping.value = crunch.damping.maximum - fractionalHeight * (crunch.damping.maximum - crunch.damping.minimum);
    crunch.pan.value = pan;
    [crunchInstrument playNote:crunch];
}

- (void)haloHitShieldAtPosition:(CGPoint)position {
    [self haloHitBallAtPosition:position];
}

- (void)haloHitLifeBar
{
    Crunch *deepCrunch = [[Crunch alloc] initAsDeepCrunch];
    deepCrunch.duration.value = 2.0;
    [crunchInstrument playNote:deepCrunch];
}

// -----------------------------------------------------------------------------
#  pragma mark - Shield Power Up Events
// -----------------------------------------------------------------------------

- (void)spawnedShieldPowerUpAtPosition:(CGPoint)position {
    [sirenInstrument playForDuration:5.0];
}

- (void)updateShieldPowerUpPosition:(CGPoint)position
{
    float pan  = position.x / playFieldSize.width * 2.0 - 1.0;
    sirenInstrument.pan.value = pan;
}

- (void)replacedShieldAtPosition:(CGPoint)position {
    [sirenInstrument stop];
    float pan  = position.x / playFieldSize.width * 2.0 - 1.0;
    Zwoop *zwoop = [[Zwoop alloc] initWithPan:pan];
    [zwoopInstrument playNote:zwoop];
}


// -----------------------------------------------------------------------------
#  pragma mark - Player Events
// -----------------------------------------------------------------------------

- (void)playerShotBallWithRotationVector:(CGVector)rotationVector remaningAmmo:(int)remainingAmmo
{
    LaserNote *laser = [[LaserNote alloc] initWithSpeed:(6.0 / (remainingAmmo + 1)) pan:(1.0 + rotationVector.dx) / 2.0];
    [laserInstrument playNote:laser];
}

- (void)attemptedShotWithoutAmmo {
    LaserNote *laser = [[LaserNote alloc] initWithSpeed:10.0 pan:0.5];
    [laserInstrument playNote:laser];
}

- (void)ballBouncedAtPosition:(CGPoint)position
{
    float pan  = position.x / playFieldSize.width * 2.0 - 1.0;
    float amplitude = (playFieldSize.height - position.y) / playFieldSize.height;
    SoftBoing *note = [[SoftBoing alloc] initWithPan:pan];
    note.amplitude.value = amplitude;
    [softBoingInstrument playNote:note];
}

- (void)multiplierModeStartedWithPointValue:(int)points {
    float feedbackLevel = 0.8 + (0.2 * (points - 1)) / (float)points;
    spaceVerb.feedbackLevel.value = feedbackLevel;
}

- (void)multiplierModeEnded {
    spaceVerb.feedbackLevel.value = 0.8;
}

@end
