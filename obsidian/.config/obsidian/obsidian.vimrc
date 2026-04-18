unmap <Space>

set clipboard=unnamed

" ── Window navigation (mirrors <leader>w* in LazyVim) ──────────────────────
exmap focusLeft obcommand editor:focus-left
exmap focusRight obcommand editor:focus-right
exmap focusTop obcommand editor:focus-top
exmap focusBottom obcommand editor:focus-bottom

nmap <Space>wh :focusLeft<CR>
nmap <Space>wl :focusRight<CR>
nmap <Space>wk :focusTop<CR>
nmap <Space>wj :focusBottom<CR>

" ── Splits (mirrors <leader>v / <leader>h) ─────────────────────────────────
exmap splitVertical obcommand workspace:split-vertical
exmap splitHorizontal obcommand workspace:split-horizontal

nmap <Space>v :splitVertical<CR>
nmap <Space>h :splitHorizontal<CR>

" ── Tabs (mirrors gt / gT with bufferline) ─────────────────────────────────
exmap nextTab obcommand workspace:next-tab
exmap prevTab obcommand workspace:previous-tab

nmap gt :nextTab<CR>
nmap gT :prevTab<CR>

" ── Buffer / file (mirrors <leader>b* / <leader>f*) ───────────────────────
exmap closeTab obcommand workspace:close
nmap <Space>bd :closeTab<CR>

exmap newNote obcommand file-explorer:new-file
nmap <Space>fn :newNote<CR>

exmap renameFile obcommand workspace:edit-file-title
nmap <Space>cr :renameFile<CR>

" ── Sidebar (mirrors <leader>e NeoTree) ────────────────────────────────────
exmap toggleLeftSidebar obcommand app:toggle-left-sidebar
exmap toggleRightSidebar obcommand app:toggle-right-sidebar

nmap <Space>e :toggleLeftSidebar<CR>
nmap <Space>er :toggleRightSidebar<CR>

" ── Search (mirrors <leader>ff / <leader>sg) ───────────────────────────────
exmap quickOpen obcommand switcher:open
nmap <Space><Space> :quickOpen<CR>
nmap <Space>ff :quickOpen<CR>

exmap searchGlobal obcommand global-search:open
nmap <Space>sg :searchGlobal<CR>

" ── History navigation (standard Vim <C-o> / <C-i>) ───────────────────────
exmap goBack obcommand app:go-back
exmap goForward obcommand app:go-forward

nmap <C-o> :goBack<CR>
nmap <C-i> :goForward<CR>

" ── LSP-like actions (mirrors <leader>g* / <leader>c*) ────────────────────
exmap followLink obcommand editor:follow-link
nmap <Space>gd :followLink<CR>
nmap gd :followLink<CR>

exmap commandPalette obcommand command-palette:open
nmap <Space>ca :commandPalette<CR>

" ── Obsidian-specific (mirrors obsidian.nvim <leader>o*) ──────────────────
exmap obsidianNew obcommand obsidian:new-note
nmap <Space>on :obsidianNew<CR>

exmap obsidianDailyNote obcommand daily-notes:goto-today
nmap <Space>od :obsidianDailyNote<CR>

exmap obsidianSearch obcommand obsidian:search
nmap <Space>os :obsidianSearch<CR>

exmap obsidianBacklinks obcommand backlink:open-backlinks
nmap <Space>ob :obsidianBacklinks<CR>

exmap obsidianTogglePreview obcommand markdown:toggle-preview
nmap <Space>tp :obsidianTogglePreview<CR>

" ── Folding (standard Vim zm / zR) ─────────────────────────────────────────
exmap foldAll obcommand editor:fold-all
exmap unfoldAll obcommand editor:unfold-all

nmap zm :foldAll<CR>
nmap zR :unfoldAll<CR>

" ── Heading navigation (mirrors ]] / [[ in LazyVim markdown) ──────────────
exmap nextHeading obcommand outline:next-heading
exmap prevHeading obcommand outline:prev-heading

nmap ]] :nextHeading<CR>
nmap [[ :prevHeading<CR>

" ── Motion fixes ───────────────────────────────────────────────────────────
nmap j gj
nmap k gk

nmap H ^
nmap L $
