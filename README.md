# Marc Solitaire

#### By Mark Pazolli. Chris Aguilar and the Aiselriot team

A port Aisleriot to Apple Silicon and macOS using Chris Aguilar's cards.

## Building

Building is treacherous:

1. Download an existing binary with the pre-prepared libraries and place
them in the `Solitaire/arm64-lib` directory
2. `brew install guile@2` then follow the Guild installation instructions
3. Open `Solitaire.xcodeproj` in Xcode 12 or later and click `Build` or `Archive`
to build

## Guild installation instructions

1. `cp /opt/homebrew/Cellar/guile@2/2.2.7_3/bin/guild /opt/homebrew/Cellar/guile@2/2.2.7_3/bin/guildar`
2. Add the following lines below `;;;; Boston, MA 02110-1301 USA`:

```
(define-module (aisleriot interface))
(primitive-load-path "/Users/pazollim/Developer/solitaire/Solitaire/games-api/api.scm")
```

## License

Chris Aguilar's beautiful cards are covered by the GNU Lesser General Public
License 3.0 and can be downloaded [here](https://totalnonsense.com/open-source-vector-playing-cards/).
The LGPL coverage extends to significantly derived works `aguilar.afdesign`, `icon-i.afdesign`
and `icon-ii.afdesign`.

The `help` and `Solitaire.help` files are covered by the GNU Free Documentation License
1.1.

All code and the work as a whole is covered by the GNU General Public License 3.0.
