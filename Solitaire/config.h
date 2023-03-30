/* config.h.  Generated from config.h.in by configure.  */
/* config.h.in.  Generated from configure.ac by autoheader.  */

/* The default card theme */
#define AR_CARD_THEME_DEFAULT "gnomangelo_bitmap.svgz"

/* The default card theme format type string */
#define AR_CARD_THEME_DEFAULT_FORMAT_STRING "svg"

/* Define for binary relocation support */
/* #undef ENABLE_BINRELOC */

/* Define to enable prerendered card theme format support */
/* #undef ENABLE_CARD_THEME_FORMAT_FIXED */

/* Define to enable KDE card theme format support */
/* #undef ENABLE_CARD_THEME_FORMAT_KDE */

/* Define to enable native SVG rendering with QtSvg */
/* #undef ENABLE_CARD_THEME_FORMAT_NATIVE */

/* Define to enable PySol card theme format support */
/* #undef ENABLE_CARD_THEME_FORMAT_PYSOL */

/* Define to enable SVG card theme format support */
#define ENABLE_CARD_THEME_FORMAT_SVG 1

/* Define extra debugging UI in Aisleriot is enabled */
/* #undef ENABLE_DEBUG_UI */

/* always defined to indicate that i18n is enabled */
/* #undef ENABLE_NLS */

/* Define if sound support is enabled */
/* #undef ENABLE_SOUND */

/* The gettext package name */
#define GETTEXT_PACKAGE "aisleriot"

/* Define if debugging is enabled */
#define GNOME_ENABLE_DEBUG 1

/* Define to 1 if you have the `bind_textdomain_codeset' function. */
/* #undef HAVE_BIND_TEXTDOMAIN_CODESET */

/* Define to 1 if you have the Mac OS X function CFLocaleCopyCurrent in the
   CoreFoundation framework. */
#define HAVE_CFLOCALECOPYCURRENT 1

/* Define to 1 if you have the Mac OS X function CFPreferencesCopyAppValue in
   the CoreFoundation framework. */
#define HAVE_CFPREFERENCESCOPYAPPVALUE 1

/* Define to 1 if you have the `dcgettext' function. */
/* #undef HAVE_DCGETTEXT */

/* Define to 1 if you have the <dlfcn.h> header file. */
#define HAVE_DLFCN_H 1

/* Define if the GNU gettext() function is already present or preinstalled. */
/* #undef HAVE_GETTEXT */

/* Define if GNOME support is enabled */
/* #undef HAVE_GNOME */

/* Define to 1 if you have the <inttypes.h> header file. */
#define HAVE_INTTYPES_H 1

/* Define if your <locale.h> file defines LC_MESSAGES. */
#define HAVE_LC_MESSAGES 1

/* Define to 1 if you have the <locale.h> header file. */
#define HAVE_LOCALE_H 1

/* Define to 1 if you have the <memory.h> header file. */
#define HAVE_MEMORY_H 1

/* Refine if QtSvg is available */
/* #undef HAVE_QTSVG */

/* Refine if librsvg is available */
#define HAVE_RSVG 1

/* Define to 1 if you have the <stdint.h> header file. */
#define HAVE_STDINT_H 1

/* Define to 1 if you have the <stdlib.h> header file. */
#define HAVE_STDLIB_H 1

/* Define to 1 if you have the <strings.h> header file. */
#define HAVE_STRINGS_H 1

/* Define to 1 if you have the <string.h> header file. */
#define HAVE_STRING_H 1

/* Define to 1 if you have the <sys/stat.h> header file. */
#define HAVE_SYS_STAT_H 1

/* Define to 1 if you have the <sys/types.h> header file. */
#define HAVE_SYS_TYPES_H 1

/* Define to 1 if you have the <unistd.h> header file. */
#define HAVE_UNISTD_H 1

/* The help file format */
/* #undef HELP_FILE_FORMAT */

/* The base path to the KDE card themes */
/* #undef KDE_CARD_THEME_PATH */

/* Define to the sub-directory where libtool stores uninstalled libraries. */
#define LT_OBJDIR ".libs/"

/* Define if debugging is disabled */
#define NDEBUG /**/

/* Name of package */
#define PACKAGE "aisleriot"

/* Define to the address where bug reports for this package should be sent. */
#define PACKAGE_BUGREPORT "http://bugzilla.gnome.org/enter_bug.cgi?product=aisleriot"

/* Define to the full name of this package. */
#define PACKAGE_NAME "AisleRiot"

/* Define to the full name and version of this package. */
#define PACKAGE_STRING "AisleRiot 3.22.9"

/* Define to the one symbol short name of this package. */
#define PACKAGE_TARNAME "aisleriot"

/* Define to the home page for this package. */
#define PACKAGE_URL ""

/* Define to the version of this package. */
#define PACKAGE_VERSION "3.22.9"

/* The base path to the PySol card themes */
/* #undef PYSOL_CARD_THEME_PATH */

/* Define to 1 if you have the ANSI C header files. */
#define STDC_HEADERS 1

/* Version number of package */
#define VERSION "3.22.9"

/* Define to use help using file */
/* #undef WITH_HELP_METHOD_FILE */

/* Define to use help using ghelp */
#define WITH_HELP_METHOD_GHELP 1

/* Define to use help using library.gnome.org */
/* #undef WITH_HELP_METHOD_LIBRARY */

/*
#define PREFIX "../Resources"
#define LIBDIR "../Resources/lib"
#define DATADIR "../Resources/share"
#define PKGDATADIR "../Resources/share/aisleriot"
#define PKGLIBDIR "../Resources/lib/aisleriot"
*/

extern const char *PREFIX;
extern const char *LIBDIR;
extern const char *DATADIR;
extern const char *PKGDATADIR;
extern const char *PKGLIBDIR;
