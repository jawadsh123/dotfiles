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

## Local Extensions

### slash

Personal extension repo:

```text
git@github.com:jawadsh123/raycast-slash.git
```

Current local source checkout:

```text
~/_sand/raycast-slash
```

Fresh machine setup:

```sh
git clone git@github.com:jawadsh123/raycast-slash.git ~/_sand/raycast-slash
cd ~/_sand/raycast-slash
yarn install --frozen-lockfile
yarn build
yarn dev
```

`yarn dev` runs `ray develop`, which registers the development extension at:

```text
~/.config/raycast/extensions/slash
```

Stop the dev watcher after the extension is registered unless actively developing the extension.

Required Raycast extension preferences, set manually in Raycast:

- `githubToken`: GitHub PAT with repo scope
- `organizations`: optional comma-separated GitHub organizations
- `geminiApiKey`: Gemini API key

Do not commit those preference values.

Old Mac note:

- The old source checkout at `~/_sand/raycast-slash` had uncommitted edits in `src/blob.ts` and `src/index.tsx` when this machine was set up. The new machine currently uses clean `origin/main`; compare/harvest those edits separately if needed.
