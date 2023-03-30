//
//  SolActionDictionary.m
//  Solitaire
//
//  Created by Mark Pazolli on 9/3/2023.
//

#import <Foundation/Foundation.h>
#import "SolMenuItem.h"
#import "SolActionDictionary.h"

@implementation SolActionDictionary

- (id)initWithCapacity:(int)capacity {
    self = [super init];
    NSMutableDictionary *actions = [NSMutableDictionary dictionaryWithCapacity:capacity + 7];
    SolMenuItem *cutItem = [[SolMenuItem alloc] initWithName:@"Cut" label:@"Cut" andAccelerator:@"<Meta>X"];
    [actions setValue:cutItem forKey:[cutItem name]];
    SolMenuItem *copyItem = [[SolMenuItem alloc] initWithName:@"Copy" label:@"Copy" andAccelerator:@"<Meta>C"];
    [actions setValue:copyItem forKey:[copyItem name]];
    SolMenuItem *pasteItem = [[SolMenuItem alloc] initWithName:@"Paste" label:@"Paste" andAccelerator:@"<Meta>V"];
    [actions setValue:pasteItem forKey:[pasteItem name]];
    SolMenuItem *clearItem = [[SolMenuItem alloc] initWithName:@"Clear" label:@"Clear" andAccelerator:nil];
    [actions setValue:clearItem forKey:[clearItem name]];
    SolMenuItem *selectAllItem = [[SolMenuItem alloc] initWithName:@"SelectAll" label:@"Select All" andAccelerator:@"<Meta>A"];
    [actions setValue:selectAllItem forKey:[selectAllItem name]];
    SolMenuItem *emptyOptions = [[SolMenuItem alloc] initPlaceholderWithName:@"EmptyOptions" label:@"No Game Options"];
    [actions setValue:emptyOptions forKey:[emptyOptions name]];
    SolMenuItem *help = [[SolMenuItem alloc] initAsHelp];
    [actions setValue:help forKey:[help name]];
    SolMenuItem *gameHelp = [[SolMenuItem alloc] initAsGameHelp];
    [actions setValue:gameHelp forKey:[gameHelp name]];
    SolMenuItem *sourceCode = [[SolMenuItem alloc] initAsSourceCode];
    [actions setValue:sourceCode forKey:[sourceCode name]];
    
    self->actions = actions;
    return self;
}

- (SolMenuItem *)get:(NSString *)key {
    return [actions objectForKey:key];
}

- (void)addActions:(GtkActionEntry *)newActions count:(int)count {
    for (int i = 0; i < count; i++) {
        SolMenuItem *menuItem = [[SolMenuItem alloc] initWithActionEntry:&newActions[i]];
        [actions setValue:menuItem forKey:[menuItem name]];
    }
}

- (void)addToggleActions:(GtkToggleActionEntry *)newActions count:(int)count {
    for (int i = 0; i < count; i++) {
        SolMenuItem *menuItem = [[SolMenuItem alloc] initWithToggleActionEntry:&newActions[i]];
        [actions setValue:menuItem forKey:[menuItem name]];
    }
}

@end

SolActionDictionary *createActionDictionary(int capcity) {
    return [[SolActionDictionary alloc] initWithCapacity:capcity];
}

void addActions(SolActionDictionary *dict, GtkActionEntry *actions, int count) {
    return [dict addActions:actions count:count];
}

void addToggleActions(SolActionDictionary *dict, GtkToggleActionEntry *actions, int count) {
    return [dict addToggleActions:actions count:count];
}
