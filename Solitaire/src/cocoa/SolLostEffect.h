//
//  SolLostView.h
//  Solitaire
//
//  Created by Mark Pazolli on 27/3/2023.
//

#ifndef SolLostEffect_h
#define SolLostEffect_h

#import <Cocoa/Cocoa.h>

@interface SolLostEffect : NSObject {
    
    NSWindow *window;
    
    NSTimer *timer;
    
    float value;
    
}

- (id)initWithWindow:(NSWindow *)window;

- (void)increment:(id)sender;

- (void)run;

@end


#endif /* SolLostEffect_h */
