//
//  SolMenu.m
//  Solitaire
//
//  Created by Mark Pazolli on 9/3/2023.
//

#import <Foundation/Foundation.h>
#import "SolMenu.h"

@implementation SolMenu

- (id)initWithTitle:(NSString *)title {
    self = [super init];
    self->title = title;
    self->items = [NSMutableArray arrayWithCapacity:12];
    return self;
}

- (void)addMenuItem:(SolMenuItem *)item {
    [items addObject:item];
    if (manifestation) {
        [item addToMenu:manifestation andApplication:app];
    }
}

- (void)addSeparator {
    [items addObject:[[SolMenuItem alloc] initAsSeparator]];
}

- (GMenu *)dynamicMenu {
    return dynamicMenu;
}

- (void)addToMenuBar:(GMenu *)menuBar andApplication:(GtkApplication *)application {
    GMenu *menu = g_menu_new();
    
    bool useSections = false;
    
    for (int i = 0; i < [items count]; i++) {
        useSections = useSections || [[items objectAtIndex:i] isSeparator];
    }
    if (useSections) {
        GMenu *menuSection = g_menu_new();
        bool isDynamic = false;
        for (int i = 0; i < [items count]; i++) {
            SolMenuItem *menuItem = [items objectAtIndex:i];
            if ([menuItem isSeparator]) {
                g_menu_append_section(menu, NULL, G_MENU_MODEL(menuSection));
                g_object_unref(menuSection);
                menuSection = g_menu_new();
            }
            else {
                if ([menuItem isDynamicPlaceholder]) isDynamic = true;
                [menuItem addToMenu:menuSection andApplication:application];
            }
        }
        g_menu_append_section(menu, NULL, G_MENU_MODEL(menuSection));
        if (isDynamic) {
            self->dynamicMenu = menuSection;
        }
        else {
            g_object_unref(menuSection);
        }
    }
    else {
        for (int i = 0; i < [items count]; i++) {
            SolMenuItem *menuItem = [items objectAtIndex:i];
            if (![menuItem isSeparator]) {
                [menuItem addToMenu:menu andApplication:application];
            }
        }
    }
    
    g_menu_append_submenu(menuBar, [title UTF8String], G_MENU_MODEL(menu));
    
    g_object_unref(menu);
}

@end

@implementation FileMenu

- (id)initFromDictionary:(SolActionDictionary *)dict {
    self = [super initWithTitle:@"File"];
    
    [self addMenuItem:[dict get:@"NewGame"]];
    [self addMenuItem:[dict get:@"Select"]];
    [self addSeparator];
    [self addMenuItem:[dict get:@"RecentMenu"]];
    [self addSeparator];
    [self addMenuItem:[dict get:@"Statistics"]];
    [self addMenuItem:[dict get:@"RestartGame"]];
    
    return self;
}

@end

@implementation EditMenu


- (id)initFromDictionary:(SolActionDictionary *)dict {
    self = [super initWithTitle:@"Edit"];
    
    [self addMenuItem:[dict get:@"UndoMove"]];
    [self addMenuItem:[dict get:@"RedoMove"]];
    [self addSeparator];
    [self addMenuItem:[dict get:@"Cut"]];
    [self addMenuItem:[dict get:@"Copy"]];
    [self addMenuItem:[dict get:@"Paste"]];
    [self addMenuItem:[dict get:@"Clear"]];
    [self addSeparator];
    [self addMenuItem:[dict get:@"SelectAll"]];
    
    return self;
}

@end

@implementation ViewMenu

- (id)initFromDictionary:(SolActionDictionary *)dict {
    self = [super initWithTitle:@"View"];
    
    [self addMenuItem:[dict get:@"Fullscreen"]];
    [self addMenuItem:[dict get:@"Toolbar"]];
    [self addMenuItem:[dict get:@"Statusbar"]];
    
    return self;
}

@end

@implementation OptionsMenu

- (id)initFromDictionary:(SolActionDictionary *)dict {
    self = [super initWithTitle:@"Game"];
    
    [self addMenuItem:[dict get:@"ClickToMove"]];
    [self addSeparator];
    [self addMenuItem:[dict get:@"EmptyOptions"]];
    
    return self;
}

@end

@implementation HelpMenu

- (id)initFromDictionary:(SolActionDictionary *)dict {
    self = [super initWithTitle:@"Help"];
    
    [self addMenuItem:[dict get:@"Help"]];
    [self addMenuItem:[dict get:@"GameHelp"]];
    [self addSeparator];
    [self addMenuItem:[dict get:@"SourceCode"]];
    
    return self;
}


@end
