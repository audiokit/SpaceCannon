//
//  PluckyInstrument.m
//  Space Cannon
//
//  Created by Nicholas Arner on 11/29/14.
//  Copyright (c) 2014 AudioKit. All rights reserved.
//

#import "PluckyInstrument.h"

@implementation PluckyInstrument

- (instancetype)init
{
    self = [super init];
    if (self) {
        // Note Properties
        Pluck *note = [[Pluck alloc] init];
        [self addNoteProperty:note.frequency];
        [self addNoteProperty:note.pan];
        
        AKLine *decay = [[AKLine alloc]initWithFirstPoint:akp(0.5)
                                              secondPoint:akp(0)
                                    durationBetweenPoints:akp(0.25)];
        [self connect:decay];
        
        AKOscillator *oscillator = [AKOscillator oscillator];
        oscillator.frequency.value = 1;
        oscillator.amplitude = decay;
        [self connect:oscillator];
        
        // Instrument Definition
        AKPluckedString *pluck = [AKPluckedString pluckWithExcitationSignal:oscillator];
        pluck.frequency = note.frequency;
        [pluck setOptionalAmplitude:akp(0.15)];
        [pluck setOptionalReflectionCoefficient:akp(0.2)];
        [self connect:pluck];
        
        AKPanner *panner = [[AKPanner alloc] initWithInput:pluck pan:note.pan panMethod:AKPanMethodEqualPower];
        [self connect:panner];
        
        // Output to global effects processing
        _auxilliaryOutput = [AKStereoAudio globalParameter];
        [self assignOutput:_auxilliaryOutput to:panner];
    }
    return self;
}
@end

// -----------------------------------------------------------------------------
#  pragma mark - PluckyInstrument Note
// -----------------------------------------------------------------------------


@implementation Pluck

- (instancetype)init
{
    self = [super init];
    if (self) {
        _frequency = [[AKNoteProperty alloc] initWithValue:440 minimum:100 maximum:20000];
        [self addProperty:_frequency];
        
        _pan = [[AKNoteProperty alloc] initWithValue:0.0 minimum:0 maximum:1];
        [self addProperty:_pan];
        
        // Optionally set a default note duration
        self.duration.value = 1;
    }
    return self;
}

- (instancetype)initWithFrequency:(float)frequency pan:(float)pan;
{
    self = [self init];
    if (self) {
        _frequency.value = frequency;
        _pan.value = pan;
    }
    return self;
}

@end
