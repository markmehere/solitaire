//
//  SolMenuBar.m
//  Solitaire
//
//  Created by Mark Pazolli on 9/3/2023.
//

#import "SolMenuBar.h"
#import "SolActionDictionary.h"
#import "SolMenu.h"

SolMenuBar *sharedMenuBar = nil;

@implementation SolMenuBar

+ (SolMenuBar *)sharedMenuBar {
    if (!sharedMenuBar) sharedMenuBar = [[SolMenuBar alloc] init];
    return sharedMenuBar;
}

- (void)addQuickAccessItem:(NSString *)name isFresh:(bool)fresh {
    if (!quickAccessItem || fresh) {
        quickAccessItem = [NSMutableArray arrayWithCapacity:8];
    }
    [quickAccessItem addObject:name];
}

- (void)setQuickAccessItem:(int)index enabled:(bool)value {
    NSAssert(activeDictionary && quickAccessItem, @"required data not availble");
    GSimpleAction *simpleAction = [[activeDictionary get:[quickAccessItem objectAtIndex:index]] action];
    if (simpleAction) {
        g_simple_action_set_enabled(simpleAction, value);
    }
}

- (void)setItem:(NSString *)name value:(bool)value {
    NSAssert(activeDictionary, @"required data not availble");
    GSimpleAction *simpleAction = [[activeDictionary get:name] action];
    if (simpleAction) {
        GVariant *oldVariant = g_action_get_state(G_ACTION(simpleAction));
        g_variant_unref(oldVariant);
        GVariant *variant = g_variant_new_boolean(value);
        g_simple_action_set_state(simpleAction, variant);
    }
}

- (void)addRecentGame:(NSString *)gameName fullName:(NSString *)fullName callback:(GCallback)callback isFresh:(bool)fresh withApplication:(GtkApplication *)application {
    NSAssert(activeDictionary && [activeDictionary get:@"RecentMenu"], @"required data not availble");
    GMenu *recentMenu = [[activeDictionary get:@"RecentMenu"] submenu];
    if (fresh) {
        g_menu_remove_all(recentMenu);
    }
    SolMenuItem *recentEntry = [[SolMenuItem alloc] initWithRecentGame:gameName fullName:fullName callback:callback];
    [recentEntry addToMenu:recentMenu andApplication:application];
}

- (void)addToApplication:(GtkApplication *)application usingDictionary:(SolActionDictionary *)dict {
    GMenu *menuBar = g_menu_new();
    
    activeDictionary = dict;

    [[NSHelpManager sharedHelpManager] registerBooksInBundle:[NSBundle mainBundle]];
    FileMenu *fileMenu = [[FileMenu alloc] initFromDictionary:dict];
    EditMenu *editMenu = [[EditMenu alloc] initFromDictionary:dict];
    OptionsMenu *optionsMenu = [[OptionsMenu alloc] initFromDictionary:dict];
    ViewMenu *viewMenu = [[ViewMenu alloc] initFromDictionary:dict];
    HelpMenu *helpMenu = [[HelpMenu alloc] initFromDictionary:dict];
    
    [fileMenu addToMenuBar:menuBar andApplication:application];
    [editMenu addToMenuBar:menuBar andApplication:application];
    [optionsMenu addToMenuBar:menuBar andApplication:application];
    [viewMenu addToMenuBar:menuBar andApplication:application];
    [helpMenu addToMenuBar:menuBar andApplication:application];
    
    dynamicOptionsMenu = [optionsMenu dynamicMenu];
    
    gtk_application_set_menubar(application, G_MENU_MODEL(menuBar));

    g_object_unref(menuBar);
}

- (void)resetOptionsMenuForApplication:(GtkApplication *)application {
    NSAssert(activeDictionary && [activeDictionary get:@"EmptyOptions"] && dynamicOptionsMenu, @"required data not availble");
    g_menu_remove_all(dynamicOptionsMenu);
    [[activeDictionary get:@"EmptyOptions"] addToMenu:dynamicOptionsMenu andApplication:application];
}

- (void)addCheckOption:(NSString *)name label:(NSString *)label andCallback:(GCallback)callback isFresh:(bool)isFresh setting:(bool)curValue withApplication:(GtkApplication *)application {
    NSAssert(dynamicOptionsMenu, @"dynamicOptionsMenu not availble");
    NSAssert([[name substringToIndex:strlen("Option")] isEqualToString:@"Option"], @"unexpected string format");
    if (isFresh) {
        g_menu_remove_all(dynamicOptionsMenu);
        optionGroupings = [NSMutableArray arrayWithCapacity:5];
        nameToGrouping = [NSMutableDictionary dictionaryWithCapacity:5];
        optionChecks = [NSMutableArray arrayWithCapacity:5];
    }
    SolMenuItem *menuItem = [[SolMenuItem alloc] initWithName:name label:label value:curValue andCallback:callback];
    [menuItem addToMenu:dynamicOptionsMenu andApplication:application];
    [optionChecks addObject:menuItem];
}

- (void)addRadioOption:(NSString *)name label:(NSString *)label groupPos:(int)pos andCallback:(GCallback)callback isFresh:(bool)isFresh setting:(bool)curValue withApplication:(GtkApplication *)application  {
    NSAssert(dynamicOptionsMenu, @"dynamicOptionsMenu not availble");
    NSAssert([[name substringToIndex:strlen("Option")] isEqualToString:@"Option"], @"unexpected string format");
    if (isFresh) {
        g_menu_remove_all(dynamicOptionsMenu);
        optionGroupings = [NSMutableArray arrayWithCapacity:5];
        nameToGrouping = [NSMutableDictionary dictionaryWithCapacity:5];
        optionChecks = [NSMutableArray arrayWithCapacity:5];
    }
    SolMenuItem *menuItem = [[SolMenuItem alloc] initWithName:name label:label value:curValue andCallback:callback];
    if (pos == 0) {
        [optionGroupings addObject:[NSMutableArray arrayWithCapacity:5]];
    }
    NSMutableArray *groupings = [optionGroupings objectAtIndex:[optionGroupings count] - 1];
    [groupings addObject:menuItem];
    [nameToGrouping setObject:groupings forKey:[menuItem name]];
    [menuItem addToMenu:dynamicOptionsMenu andApplication:application];
}

- (guint32)clearAllRadiosInGroup:(NSString *)name withMask:(guint32 *)mask {
    if ([nameToGrouping objectForKey:name]) {
        NSMutableArray *allRadios = [nameToGrouping objectForKey:name];
        NSMutableArray *allRadioNames = [NSMutableArray arrayWithCapacity:[allRadios count]];
        for (int i = 0; i < [allRadios count]; i++) {
            SolMenuItem *menuItem = [allRadios objectAtIndex:i];
            [allRadioNames addObject:[menuItem name]];
            GSimpleAction *action = [menuItem action];
            GVariant *variant = g_action_get_state(G_ACTION(action));
            GVariant *updatedVariant = g_variant_new_boolean([name isEqualToString:[menuItem name]]);
            g_simple_action_set_state(action, updatedVariant);
            g_variant_unref(variant);
        }
    }

    
    guint32 result = 0;
    
    for (int i = 0; i < [optionChecks count]; i++) {
        SolMenuItem *menuItem = [optionChecks objectAtIndex:i];
        guint32 value = (guint32)[[[menuItem name] substringFromIndex:strlen("Option")] integerValue];
        GVariant *variant = g_action_get_state(G_ACTION([menuItem action]));
        bool active = g_variant_get_boolean(variant);
        if (mask) *mask |= value;
        if (active) result |= value;
    }
    
    for (int j = 0; j < [optionGroupings count]; j++) {
        for (int i = 0; i < [[optionGroupings objectAtIndex:j] count]; i++) {
            SolMenuItem *menuItem = [[optionGroupings objectAtIndex:j] objectAtIndex:i];
            guint32 value = (guint32)[[[menuItem name] substringFromIndex:strlen("Option")] integerValue];
            GVariant *variant = g_action_get_state(G_ACTION([menuItem action]));
            bool active = g_variant_get_boolean(variant);
            if (mask) *mask |= value;
            if (active) result |= value;
        }
    }
    return result;
}

@end

void addRecentGame(GtkApplication *application, const char *gameName, const char *fullName, GCallback callback, bool isFresh) {
    [[SolMenuBar sharedMenuBar] addRecentGame:[NSString stringWithUTF8String:gameName] fullName:[NSString stringWithUTF8String:fullName] callback:callback isFresh:isFresh withApplication:application];
}

void addQuickAccessItem(const char *name, bool fresh) {
    [[SolMenuBar sharedMenuBar] addQuickAccessItem:[NSString stringWithUTF8String:name] isFresh:fresh];
}

void setQuickAccessItemEnabled(int index, bool value) {
    [[SolMenuBar sharedMenuBar] setQuickAccessItem:index enabled:value];
}

void setItemChecked(const char *name, bool value) {
    [[SolMenuBar sharedMenuBar] setItem:[NSString stringWithUTF8String:name] value:value];
}

void createMenuBar(GtkApplication *application, SolActionDictionary *dict, GtkWindow *window) {
    return [[SolMenuBar sharedMenuBar] addToApplication:application usingDictionary:dict];
}

void resetOptionsMenu(GtkApplication *application) {
    return [[SolMenuBar sharedMenuBar] resetOptionsMenuForApplication:application];
}

void addCheckOption(const char *actionname, const char *display_name, GCallback option_cb, bool isFresh, bool curValue, GtkApplication *application) {
    return [[SolMenuBar sharedMenuBar] addCheckOption:[NSString stringWithUTF8String:actionname] label:[NSString stringWithUTF8String:display_name] andCallback:option_cb isFresh:isFresh setting:curValue withApplication:application];
}

void addRadioOption(const char *actionname, const char *display_name, int radion, GCallback option_cb, bool isFresh, bool curValue, GtkApplication *application) {
    return [[SolMenuBar sharedMenuBar] addRadioOption:[NSString stringWithUTF8String:actionname] label:[NSString stringWithUTF8String:display_name] groupPos:radion andCallback:option_cb isFresh:isFresh setting:curValue withApplication:application];
}

guint32 clearAllRadiosInGroup(const char *name, guint32 *mask) {
    return [[SolMenuBar sharedMenuBar] clearAllRadiosInGroup:[NSString stringWithUTF8String:name] withMask:mask];
}
