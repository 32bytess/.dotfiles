" Mirrors ~/.config/nvim (albertoodev/nvim). Leader is <Space>.
" Not settable from here: number / relativenumber / cursorline / timeoutlen.
" Line numbers are a per-vault Obsidian setting (Editor -> Show line number).
unmap <Space>

" options.lua: clipboard=unnamedplus (CodeMirror-vim only knows "unnamed")
set clipboard=unnamed

" ── keymaps.lua: <Esc> clears search highlight ─────────────────────────────
nmap <Esc> :nohl<CR>

" ── Window navigation ──────────────────────────────────────────────────────
exmap focusLeft obcommand editor:focus-left
exmap focusRight obcommand editor:focus-right
exmap focusTop obcommand editor:focus-top
exmap focusBottom obcommand editor:focus-bottom

nmap <Space>wh :focusLeft<CR>
nmap <Space>wl :focusRight<CR>
nmap <Space>wk :focusTop<CR>
nmap <Space>wj :focusBottom<CR>

" ── Splits ─────────────────────────────────────────────────────────────────
exmap splitVertical obcommand workspace:split-vertical
exmap splitHorizontal obcommand workspace:split-horizontal

nmap <Space>v :splitVertical<CR>
nmap <Space>h :splitHorizontal<CR>

" ── Tabs / buffers ─────────────────────────────────────────────────────────
exmap nextTab obcommand workspace:next-tab
exmap prevTab obcommand workspace:previous-tab
exmap closeTab obcommand workspace:close

nmap gt :nextTab<CR>
nmap gT :prevTab<CR>
nmap <Space>bd :closeTab<CR>

" ── telescope.lua: find / grep / buffers ───────────────────────────────────
exmap quickOpen obcommand switcher:open
exmap searchGlobal obcommand global-search:open

nmap <Space><Space> :quickOpen<CR>
nmap <Space>ff :quickOpen<CR>
nmap <Space>fb :quickOpen<CR>
nmap <Space>fg :searchGlobal<CR>

" ── oil.lua: <Space>e float explorer, - parent dir ─────────────────────────
exmap toggleLeftSidebar obcommand app:toggle-left-sidebar
exmap toggleRightSidebar obcommand app:toggle-right-sidebar
exmap revealFile obcommand file-explorer:reveal-active-file

nmap <Space>e :toggleLeftSidebar<CR>
nmap <Space>er :toggleRightSidebar<CR>
nmap - :revealFile<CR>

" ── History (standard <C-o> / <C-i>) ───────────────────────────────────────
exmap goBack obcommand app:go-back
exmap goForward obcommand app:go-forward

nmap <C-o> :goBack<CR>
nmap <C-i> :goForward<CR>

" ── lsp_attach.lua: gd / gr / <leader>rn / <leader>ca ──────────────────────
exmap followLink obcommand editor:follow-link
exmap openBacklinks obcommand backlink:open
exmap renameFile obcommand workspace:edit-file-title
exmap commandPalette obcommand command-palette:open

nmap gd :followLink<CR>
nmap gr :openBacklinks<CR>
nmap <Space>rn :renameFile<CR>
nmap <Space>ca :commandPalette<CR>

" ── obsidian.lua (obsidian.nvim <leader>o*) ────────────────────────────────
exmap newNote obcommand file-explorer:new-file
exmap dailyNote obcommand daily-notes:goto-today
exmap outgoingLinks obcommand outgoing-links:open
exmap tagPane obcommand tag-pane:open

nmap <Space>on :newNote<CR>
nmap <Space>of :quickOpen<CR>
nmap <Space>os :searchGlobal<CR>
nmap <Space>od :dailyNote<CR>
nmap <Space>ob :openBacklinks<CR>
nmap <Space>ol :outgoingLinks<CR>
nmap <Space>ot :tagPane<CR>
nmap <Space>or :renameFile<CR>

exmap togglePreview obcommand markdown:toggle-preview
nmap <Space>tp :togglePreview<CR>

" ── harpoon.lua -> Bookmarks / tab slots ───────────────────────────────────
exmap bookmarkAdd obcommand bookmarks:bookmark-current-view
exmap bookmarkList obcommand bookmarks:open
exmap goTab1 obcommand workspace:goto-tab-1
exmap goTab2 obcommand workspace:goto-tab-2
exmap goTab3 obcommand workspace:goto-tab-3
exmap goTab4 obcommand workspace:goto-tab-4

nmap <Space>a :bookmarkAdd<CR>
nmap <Space>l :bookmarkList<CR>
nmap <Space>fh :bookmarkList<CR>
nmap <Space>1 :goTab1<CR>
nmap <Space>2 :goTab2<CR>
nmap <Space>3 :goTab3<CR>
nmap <Space>4 :goTab4<CR>

" ── gitsigns.lua / lazygit.lua / telescope git -> Obsidian Git ─────────────
exmap gitNextHunk obcommand obsidian-git:next-hunk
exmap gitPrevHunk obcommand obsidian-git:prev-hunk
exmap gitStageHunk obcommand obsidian-git:stage-hunk
exmap gitResetHunk obcommand obsidian-git:reset-hunk
exmap gitPreviewHunk obcommand obsidian-git:preview-hunk
exmap gitBlame obcommand obsidian-git:toggle-line-author-info
exmap gitView obcommand obsidian-git:open-git-view
exmap gitDiff obcommand obsidian-git:open-diff-view
exmap gitHistory obcommand obsidian-git:open-history-view
exmap gitBranch obcommand obsidian-git:switch-branch

nmap ]c :gitNextHunk<CR>
nmap [c :gitPrevHunk<CR>
nmap <Space>ghs :gitStageHunk<CR>
nmap <Space>ghr :gitResetHunk<CR>
nmap <Space>ghp :gitPreviewHunk<CR>
nmap <Space>tb :gitBlame<CR>
nmap <Space>gg :gitView<CR>
nmap <Space>gs :gitView<CR>
nmap <Space>gd :gitDiff<CR>
nmap <Space>gl :gitHistory<CR>
nmap <Space>gb :gitBranch<CR>

" ── Folding (standard Vim zm / zR) ─────────────────────────────────────────
exmap foldAll obcommand editor:fold-all
exmap unfoldAll obcommand editor:unfold-all

nmap zm :foldAll<CR>
nmap zR :unfoldAll<CR>

" ── Heading navigation (markdown ]] / [[) ──────────────────────────────────
exmap nextHeading obcommand outline:next-heading
exmap prevHeading obcommand outline:prev-heading

nmap ]] :nextHeading<CR>
nmap [[ :prevHeading<CR>

" ── Motion fixes ───────────────────────────────────────────────────────────
nmap j gj
nmap k gk

nmap H ^
nmap L $
