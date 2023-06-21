//
//  main.m
//  Solitaire
//
//  Created by Mark Pazolli on 8/3/2023.
//

#import <Foundation/Foundation.h>
#import "./src/sol.h"
#include <glib.h>

const char *executablePath;
/*
#define PREFIX "../Resources"
#define LIBDIR "../Resources/lib"
#define DATADIR "../Resources/share"
#define PKGDATADIR "../Resources/share/aisleriot"
#define PKGLIBDIR "../Resources/lib/aisleriot"
*/

const char *PREFIX;
const char *LIBDIR;
const char *DATADIR;
const char *PKGDATADIR;
const char *PKGLIBDIR;
const char *GUILECACHEDIR;

int main(int argc, const char * argv[]) {
    const char* editedArg[] = { "" };
    PREFIX = [[[NSBundle mainBundle] resourcePath] UTF8String];
    LIBDIR = [[[[NSBundle mainBundle] resourcePath] stringByAppendingString:@"/lib"] UTF8String];
    DATADIR = [[[[NSBundle mainBundle] resourcePath] stringByAppendingString:@"/share"] UTF8String];
    PKGDATADIR = [[[[NSBundle mainBundle] resourcePath] stringByAppendingString:@"/share/aisleriot"] UTF8String];
    PKGLIBDIR = [[[[NSBundle mainBundle] resourcePath] stringByAppendingString:@"/lib/aisleriot"] UTF8String];
    GUILECACHEDIR = [[[[NSBundle mainBundle] resourcePath] stringByAppendingString:@"/share/guile/ccache"] UTF8String];
    g_setenv("XDG_DATA_DIRS", DATADIR, true);
    sol(0, (char **)editedArg);
}
