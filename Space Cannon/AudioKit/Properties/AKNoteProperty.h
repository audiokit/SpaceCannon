//
//  AKNoteProperty.h
//  AudioKit
//
//  Created by Aurelius Prochazka on 9/22/12.
//  Copyright (c) 2012 Hear For Yourself. All rights reserved.
//

#import "AKConstant.h"

/** Note properties are properties of an instrument that are defined
 per each note generated by an instrument.
 */

@class AKNote;

@interface AKNoteProperty : AKConstant 

/// Current value of the property.
@property (nonatomic, assign) Float32 value;

/// Start value for initialization.
@property (nonatomic, assign) float initialValue;

/// Minimum Value allowed.
@property (nonatomic, assign) Float32 minimum;

/// Maximum Value allowed.
@property (nonatomic, assign) Float32 maximum;

/// Optional pretty name for properties useful for debugging.
@property (nonatomic, strong) NSString *name;

/// Note this property belongs to
@property (nonatomic, strong) AKNote *note;

/// Internal reference number
@property (assign) int pValue;


/// Initialize the property with bounds.
/// @param minimum Minimum value.
/// @param maximum Maximum value.
- (instancetype)initWithMinimum:(float)minimum
                        maximum:(float)maximum;

/// Initialize the property with an initial value and bounds.
/// @param initialValue Initial value.
/// @param minimum Minimum value.
/// @param maximum Maximum value.
- (instancetype)initWithValue:(float)initialValue
                      minimum:(float)minimum
                      maximum:(float)maximum;

/// Sets the current value to the initial value.
- (void)reset;

/// Randomize the current value between the minimum and maximum values
- (void)randomize;

+ (instancetype)duration;

@end
