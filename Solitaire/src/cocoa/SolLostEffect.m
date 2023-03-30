//
//  SolFailedView.m
//  Marc Solitaire
//
//  Created by Mark Pazolli on 27/3/2023.
//

#import "SolLostEffect.h"
#import "Cocoa/Cocoa.h"
#import "CoreImage/CoreImage.h"

@implementation SolLostEffect

- (id)initWithWindow:(NSWindow *)window {
    self = [super init];
    self->window = window;
    return self;
}

- (void)increment:(id)sender {
    if (value - 0.11 < 0.0) {
        CIFilter *filter = [CIFilter filterWithName:@"CIColorControls" keysAndValues:@"inputBrightness", [NSNumber numberWithFloat:0.0], @"inputContrast", [NSNumber numberWithFloat:1.0], @"inputSaturation", [NSNumber numberWithFloat:0.0], nil];
        NSArray *filters = [NSArray arrayWithObjects:filter, nil];
        [[window contentView] setContentFilters:filters];
        [timer invalidate];
        timer = nil;
        [[NSAlert alertWithMessageText:@"There are no more moves" defaultButton:@"Ok" alternateButton:nil otherButton:nil informativeTextWithFormat:@"The computer believes there are no more valid moves available."] runModal];
    }
    else {
        value -= 0.1;
        CIFilter *filter = [CIFilter filterWithName:@"CIColorControls" keysAndValues:@"inputBrightness", [NSNumber numberWithFloat:0.0], @"inputContrast", [NSNumber numberWithFloat:1.0], @"inputSaturation", [NSNumber numberWithFloat:value], nil];
        NSArray *filters = [NSArray arrayWithObjects:filter, nil];
        [[window contentView] setContentFilters:filters];
    }
}

- (void)run {
    value = 1.0;
    if (!timer) {
        timer = [NSTimer scheduledTimerWithTimeInterval:0.1
            target:self
            selector:@selector(increment:)
            userInfo:nil
            repeats:YES];
    }
}

@end
