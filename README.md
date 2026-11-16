#           ❄︎ WinterIsComing ❄︎

Let it snow on your Mac! ☃️

Snow falls on your desktop and piles up on your windows and Dock. Roll it into snowballs and build a little snowman. It's all one Swift file, and every flake is drawn in code.

<!-- ![demo](docs/demo.gif) -->

## What it can do ✨

- 🌨️ **Cozy snowfall**: three layers of flakes (near, middle and far) drifting in a gentle wind
- 🪟 **All flake sizes over windows**: optionally let medium and large flakes fall in front of windows too
- 🏔️ **Snow piles up** on top of your windows, along the Dock and at the bottom of the screen
- ❄️ **Toggle snow accumulation** to keep the snowfall without snow settling on surfaces
- 🪟 **Drag a window and *whoosh*!** The snow flies off. The faster you drag, the farther it goes
- ⚪ **Roll snowballs** just by moving your mouse sideways over the snow (no clicking!). They grow as they roll
- 🎳 **Snowballs push each other** along, and one that's pushed off the edge falls down
- 🖐️ **Hold a snowball** with the left mouse button and carry it anywhere
- ⛄ **Stack three snowballs** and they turn into a snowman with a carrot nose and a red scarf
- 💥 **A falling snowball goes *poof*** into a soft heap of snow, ready to be rolled again

## Try it 🚀

```sh
git clone https://github.com/<your-username>/WINTER_IS_COMING.git
cd WINTER_IS_COMING
zsh build.sh
```

Use the ❄︎ in the menu bar to pause, pick light, medium, heavy or **Extra Heavy** snow, toggle **Snow Accumulation**, clear the snow, or quit. Extra Heavy targets 1,000 falling flakes, twice as many as Heavy.

**Snow Accumulation** is on by default. Turn it off to immediately clear existing piles, loose clumps and snowballs while flakes keep falling. Turn it back on to let snow build up again. Your choice is remembered when you restart the app.

**All Flake Sizes over Windows** is off by default: only some of the smallest flakes fall in front of windows, while other flakes land on or disappear behind them. Turn it on to allow the same foreground share from every size layer, keeping medium and large flakes visible over windows too. Flakes keep their original size, speed and opacity. The switch takes effect immediately and your choice is remembered when you restart the app.

- No `swiftc`? Run `xcode-select --install` first.
- Want snow on the Dock too? Turn on **Terminal** in System Settings → Privacy & Security → Accessibility.

## Make it yours 🎨

Every setting lives at the top of `WinterIsComing.swift` (`enum Cfg`): how many flakes fall, how fast they fall, how tall the piles get, how big a snowball can grow… Change a number and run `zsh build.sh` again.

## License

[MIT](LICENSE) · Made with 💙 and a little help from Claude
