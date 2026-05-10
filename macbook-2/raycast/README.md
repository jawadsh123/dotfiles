# Raycast

Raycast is installed declaratively as a Homebrew cask in `../darwin-configuration.nix`.

Declarative defaults currently managed:

- Raycast global hotkey: `Command-49` (`Cmd-Space`)
- macOS Spotlight hotkey `64`: disabled, so it does not conflict with Raycast
- macOS Finder search hotkey `65`: disabled, so it does not conflict with Raycast/Spotlight behavior

After changing these defaults, run `darwin-switch`, then log out and back in before judging shortcut behavior. macOS does not reliably re-register global shortcuts live after `com.apple.symbolichotkeys` changes.

Observed old Mac values:

```text
defaults read com.raycast.macos raycastGlobalHotkey
Command-49
```

```text
AppleSymbolicHotKeys:64
enabled = false
parameters = (32, 49, 1048576)
```

```text
AppleSymbolicHotKeys:65
enabled = false
parameters = (32, 49, 1572864)
```

Not currently managed:

- Raycast login/session state
- extension auth
- extension databases under `~/Library/Application Support/com.raycast.macos`
- generated/local preference noise such as window positions, analytics IDs, onboarding state, and extension usage state

Those should be restored through Raycast sign-in/sync or handled manually unless we later identify stable, safe preferences worth declaring.
