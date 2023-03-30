//
//  SolActionDictionary.h
//  Solitaire
//
//  Created by Mark Pazolli on 9/3/2023.
//

#ifndef SolActionDictionary_h
#define SolActionDictionary_h

#import <Cocoa/Cocoa.h>
#import <gtk/gtk.h>
#import "SolMenuItem.h"

@interface SolActionDictionary : NSObject {
    
    NSMutableDictionary *actions;
    
}

- (id)initWithCapacity:(int)capacity;

- (SolMenuItem *)get:(NSString *)key;

- (void)addActions:(GtkActionEntry *)newActions count:(int)count;

- (void)addToggleActions:(GtkToggleActionEntry *)newActions count:(int)count;

@end

extern SolActionDictionary *createActionDictionary(int capcity);

extern void addActions(SolActionDictionary *dict, GtkActionEntry *actions, int count);

extern void addToggleActions(SolActionDictionary *dict, GtkToggleActionEntry *actions, int count);

#endif /* SolActionDictionary_h */
