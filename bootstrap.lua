#!/usr/bin/env lua
-- ─────────────────────────────────────────────────────────────────────────────
-- bootstrap.lua — reproducible machine setup from ~/.dotfiles
--
-- usage:
--   lua bootstrap.lua            full setup (brew bundle → stow → mise install)
--   lua bootstrap.lua --stow     only (re)stow dotfiles packages
--   lua bootstrap.lua --dry      print actions without running anything
--
-- Does NOT touch secrets. GPG/SSH keys and the pass store are manual —
-- see MIGRATION.md.
-- ─────────────────────────────────────────────────────────────────────────────

local DOTFILES_REPO = "https://github.com/lakubudavid/.dotfiles.git"
local PASS_REPO     = "https://github.com/lakubuDavid/pass-store.git"  -- manual only, never auto-cloned

local HOME = os.getenv("HOME") or error("HOME is not set")
local DOTFILES = HOME .. "/.dotfiles"

-- stow packages that work on every OS
local PORTABLE = {
  "alacritty", "bat", "broot", "gemini", "ghostty", "git", "gitconfig",
  "helix", "kitty", "mise", "oh-my-posh", "opencode", "scripts",
  "smartcat", "yazi", "zed", "zellij", "zewrap", "zshrc",
}

-- macOS-only packages (window management / key remapping)
local MAC_ONLY = { "borders", "karabiner", "skhd", "yabai" }

-- taps that only exist on macOS (filtered out of Brewfile on Linux)
local MAC_ONLY_TAPS = {
  ["felixkratz/formulae"] = true,  -- borders
  ["asmvik/formulae"]     = true,  -- yabai
  ["jackielii/tap"]       = true,  -- skhd-zig
}

-- ─── flags ──────────────────────────────────────────────────────────────────
local MODE = "full"
for _, a in ipairs(arg or {}) do
  if a == "--dry" then MODE = "dry" end
  if a == "--stow" then MODE = "stow" end
end
local DRY = (MODE == "dry")

-- ─── helpers ────────────────────────────────────────────────────────────────
local function shell(cmd)
  local h = io.popen(cmd .. " 2>/dev/null")
  if not h then return "" end
  local out = h:read("*a") or ""
  h:close()
  return (out:gsub("%s+$", ""))
end

-- bin dir of a freshly-installed brew, prepended to PATH in run()
local EXTRA_PATH = nil

local function run(cmd)
  if EXTRA_PATH then
    cmd = 'export PATH="' .. EXTRA_PATH .. ':$PATH"; ' .. cmd
  end
  if DRY then
    print("    [dry] " .. cmd)
    return true
  end
  local ok = os.execute(cmd)
  if type(ok) == "boolean" then return ok end  -- Lua >= 5.2
  return ok == 0                               -- Lua 5.1
end

local function exists(path)
  local ok, _, code = os.rename(path, path)
  if not ok and code == 13 then return true end -- permission denied ⇒ exists
  return ok and true or false
end

-- find brew, checking common prefixes (Apple Silicon / Intel / Linux)
local function find_brew()
  local known = shell("command -v brew")
  if known ~= "" then return known end
  for _, prefix in ipairs({ "/opt/homebrew", "/usr/local", "/home/linuxbrew/.linuxbrew", HOME .. "/.linuxbrew" }) do
    if exists(prefix .. "/bin/brew") then
      EXTRA_PATH = prefix .. "/bin"
      return prefix .. "/bin/brew"
    end
  end
  return nil
end

local OS = shell("uname -s")              -- "Darwin" | "Linux"
local IS_MAC = (OS == "Darwin")

local C = { ok = "\27[32m✓\27[0m", bad = "\27[31m✗\27[0m", hi = "\27[1m", dim = "\27[2m", off = "\27[0m" }
local function step(msg) io.write(C.hi .. "▸ " .. C.off .. msg .. " ... ") end
local function ok(msg) print(C.ok .. " " .. (msg or "")) end
local function skip(msg) print(C.dim .. "skipped (" .. msg .. ")" .. C.off) end
local function fail(msg) print(C.bad .. " " .. msg) end

local failures = {}

-- ─── steps ──────────────────────────────────────────────────────────────────

-- 1. Homebrew (also works on Linux via /home/linuxbrew)
local function ensure_brew()
  step("Homebrew")
  if find_brew() then ok("found") return end
  if DRY then print("    [dry] install Homebrew") return end
  print()
  run('NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"')
  if find_brew() then ok("installed") else fail("brew install failed"); table.insert(failures, "homebrew") end
end

-- 2. dotfiles repo
local function ensure_dotfiles()
  step("dotfiles repo")
  if exists(DOTFILES .. "/.git") then
    ok("exists, pulling latest")
    run("git -C " .. DOTFILES .. " pull --ff-only origin main")
  else
    run("git clone " .. DOTFILES_REPO .. " " .. DOTFILES)
    if exists(DOTFILES) then ok("cloned") else fail("clone failed"); table.insert(failures, "dotfiles") end
  end
end

-- 3. Brewfile (on Linux: strip casks + mac-only taps/formulae)
local function brew_bundle()
  step("brew bundle")
  local brewfile = DOTFILES .. "/Brewfile"
  if not exists(brewfile) then fail("no Brewfile found in dotfiles"); table.insert(failures, "brewfile") return end

  local use = brewfile
  if not IS_MAC then
    -- build a Linux-safe Brewfile: keep tap/brew lines, drop cask/mas and mac-only taps
    local filtered, drop_tap = {}, {}
    for line in io.lines(brewfile) do
      local tap = line:match('^tap%s+"([^"]+)"')
      if tap and MAC_ONLY_TAPS[tap] then
        drop_tap[tap] = true
      elseif line:match("^cask%s") or line:match("^mas%s") then
        -- skip GUI casks & App Store entries on Linux
      elseif tap and drop_tap[tap] then
        -- skip
      else
        filtered[#filtered + 1] = line
      end
    end
    use = "/tmp/Brewfile.linux"
    if not DRY then
      local f = assert(io.open(use, "w"))
      f:write(table.concat(filtered, "\n"), "\n")
      f:close()
    end
    print(C.dim .. "    (Linux: casks & mac-only taps filtered → /tmp/Brewfile.linux)" .. C.off)
  end

  if run('brew bundle --no-lock --file="' .. use .. '"') then
    ok()
  else
    fail("some brew installs failed (often mac-only formulae on Linux) — review output above")
    table.insert(failures, "brew bundle")
  end
end

-- 4. stow
local function do_stow()
  step("stow packages")
  print()
  local has_stow = shell("command -v stow") ~= ""
  if not has_stow and EXTRA_PATH then
    has_stow = shell('PATH="' .. EXTRA_PATH .. ':$PATH" command -v stow') ~= ""
  end
  if not has_stow then
    fail("stow not found — run 'brew bundle' first (it installs stow)")
    table.insert(failures, "stow missing")
    return
  end
  local packages = {}
  for _, p in ipairs(PORTABLE) do packages[#packages + 1] = p end
  if IS_MAC then
    for _, p in ipairs(MAC_ONLY) do packages[#packages + 1] = p end
  end

  local failed = {}
  for _, pkg in ipairs(packages) do
    if exists(DOTFILES .. "/" .. pkg) then
      io.write("    " .. pkg .. " ")
      if run("stow -d " .. DOTFILES .. " -t " .. HOME .. " " .. pkg) then
        print(C.ok)
      else
        print(C.bad .. " conflict")
        failed[#failed + 1] = pkg
      end
    else
      io.write("    " .. pkg .. " ")
      skip("not in repo")
    end
  end
  if #failed > 0 then
    print("  stow conflicts: " .. table.concat(failed, ", "))
    print(C.dim .. "  → resolve by removing/relocating the conflicting real files, then re-run with --stow" .. C.off)
    table.insert(failures, "stow: " .. table.concat(failed, ","))
  else
    ok("all packages stowed")
  end
end

-- 5. mise (config comes from the stowed mise package — must run AFTER stow)
local function mise_install()
  step("mise install")
  local mise = shell("command -v mise")
  if mise == "" and EXTRA_PATH then
    mise = shell('PATH="' .. EXTRA_PATH .. ':$PATH" command -v mise')
  end
  if mise == "" then
    fail("mise not found — brew bundle should have installed it")
    table.insert(failures, "mise")
    return
  end
  if run("mise install") then
    ok("all mise tools installed")
  else
    fail("mise install had errors")
    table.insert(failures, "mise install")
  end
end

-- 6. manual checklist (never automated)
local function manual_notes()
  print()
  print(C.hi .. "Manual steps remaining (secrets & permissions):" .. C.off)
  print("  1. Restore GPG key        gpg --import <your-key>")
  print("  2. Clone pass store       git clone " .. PASS_REPO .. " ~/.password-store")
  print("  3. Restore SSH keys       ~/.ssh/")
  print("  4. macOS permissions      Karabiner-Elements, Accessibility, Input Monitoring")
  print("  5. App logins             App Store, JetBrains, etc.")
  print()
  print(C.dim .. "  See MIGRATION.md in this repo for details." .. C.off)
end

-- ─── main ───────────────────────────────────────────────────────────────────
print(C.hi .. "bootstrap.lua" .. C.off .. " — " .. OS .. (DRY and " (dry run)" or ""))
print()

if MODE == "stow" then
  do_stow()
elseif MODE == "dry" then
  ensure_brew()
  ensure_dotfiles()
  brew_bundle()
  do_stow()
  mise_install()
  manual_notes()
else
  ensure_brew()
  ensure_dotfiles()
  brew_bundle()
  do_stow()
  mise_install()
  manual_notes()
end

if #failures > 0 then
  print()
  print(C.bad .. " " .. #failures .. " step(s) had issues: " .. table.concat(failures, "; ") .. C.off)
  os.exit(1)
else
  print()
  print(C.ok .. " done — open a new terminal to pick up the stowed zsh config")
end
