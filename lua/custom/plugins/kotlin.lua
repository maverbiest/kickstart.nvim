-- AlexandrosAlexiou/kotlin.nvim — extensions for JetBrains' kotlin-lsp
--
-- Why this exists: Neovim has no handler for the `jar://` URIs that kotlin-lsp returns
-- when you jump to a symbol defined inside a dependency. `vim.lsp.util.show_document`
-- opens an empty buffer for them and then errors with "Invalid cursor line: out of range".
-- This plugin wires up the server's `decompile` command so those buffers get populated.
-- See https://github.com/Kotlin/kotlin-lsp/issues/44
--
-- NOTE: this takes ownership of the `kotlin_lsp` client, so there is deliberately no
--  `kotlin_lsp` entry in the `servers` table in init.lua. Mason still installs it there.
--
-- Optional deps not installed here (both degrade gracefully):
--  - oil.nvim    -> soft `pcall(require)`; without it, package-declaration folder nav is off
--  - trouble.nvim -> only needed by `:KotlinSymbols` / `:KotlinWorkspaceSymbols`, which
--                    would error if called. Use Telescope's `gO` / `gW` instead.
vim.pack.add { 'https://github.com/AlexandrosAlexiou/kotlin.nvim' }

-- Pin the JDK that project code is analysed against, to match `jvmToolchain(21)` in
-- loculus/backend/build.gradle. The server itself runs on its own bundled JBR, so this
-- only affects symbol resolution. Falls back to the plugin's auto-detection if absent.
local jdk21 = '/Library/Java/JavaVirtualMachines/temurin-21.jdk/Contents/Home'
if not vim.uv.fs_stat(jdk21) then jdk21 = nil end

require('kotlin').setup {
  -- Resolve the project root to the Gradle module, not the monorepo root.
  -- loculus/ has no build files at its top level, so these land on loculus/backend/.
  -- Deliberately no '.git' here: that would hoist the root up to the monorepo.
  root_markers = {
    'settings.gradle',
    'settings.gradle.kts',
    'build.gradle',
    'build.gradle.kts',
    'pom.xml',
  },

  jdk_for_symbol_resolution = jdk21,

  -- The server is essentially headless IntelliJ and settled around ~2.7 GB RSS on the
  -- backend (189 files / ~29k LOC). 4 GB leaves headroom without letting it run away.
  jvm_args = {
    '-Xmx4g',
  },

  -- Don't guess the importer; this project is Gradle.
  build_tool = 'gradle',

  -- Off by default to match how the rest of this config treats inlay hints (nothing
  -- auto-enables them). Toggle per-buffer with `<leader>th`, or flip this to true.
  inlay_hints = {
    enabled = false,
  },
}
