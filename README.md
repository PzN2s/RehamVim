<div align="center">

<h1>rehamvim</h1>

<p><i>a neovim setup that just works</i></p>

![rehamvim](rehamvim.gif)

<p>
<img src="https://img.shields.io/badge/neovim-0.12%2B-bcd596?style=for-the-badge&logo=neovim&logoColor=white&labelColor=161a17" alt="neovim 0.12+">
<img src="https://img.shields.io/badge/license-apache--2.0-a7c080?style=for-the-badge&labelColor=161a17" alt="apache 2.0">
<img src="https://img.shields.io/badge/themes-10-96a468?style=for-the-badge&labelColor=161a17" alt="10 themes">
<img src="https://img.shields.io/badge/plugins-104-8e9484?style=for-the-badge&labelColor=161a17" alt="104 plugins">
</p>

<p>built on <a href="https://lazyvim.github.io">lazyvim</a> and forked from <a href="https://github.com/sam0uly/SamoulyVim">samoulyvim</a></p>

</div>

## ✦ what you get

- ✧ **languages** go rust c/c++ typescript python vue lua nix bash and more each with lsp
- ✧ **dev tools** debugger test runner formatters lazygit right click menu
- ✧ **looks** custom dashboard file tree fuzzy pickers and ten themes named after their colour
- ✧ **health** `:RehamCheck` runs real checks and says if anything is broken

## ✦ install

needs neovim 0.12 or newer plus `git` `curl` and `gcc`

**clone and start**

```sh
git clone https://github.com/PzN2s/RehamVim ~/.config/nvim && nvim
```

**one line installer** detects your package manager and works on nix too

```sh
bash <(curl -s https://raw.githubusercontent.com/PzN2s/RehamVim/main/install.sh)
```

**nix** isolated binary so your system neovim stays untouched

```sh
nix run github:PzN2s/RehamVim
```

plugins install themselves on first start then run `:RehamCheck`

## ✦ keys

the leader is `space`

<div align="center">

<table align="center">
<thead>
<tr><th align="center">key</th><th align="center">what it does</th></tr>
</thead>
<tbody>
<tr><td align="center"><code>space e</code></td><td align="center">file tree</td></tr>
<tr><td align="center"><code>space f f</code></td><td align="center">find files</td></tr>
<tr><td align="center"><code>space f g</code></td><td align="center">search the project</td></tr>
<tr><td align="center"><code>space f r</code></td><td align="center">recent files</td></tr>
<tr><td align="center"><code>space f b</code></td><td align="center">open buffers</td></tr>
<tr><td align="center"><code>space .</code></td><td align="center">scratchpad</td></tr>
<tr><td align="center"><code>space g g</code></td><td align="center">lazygit</td></tr>
<tr><td align="center"><code>space g W</code></td><td align="center">git worktrees</td></tr>
<tr><td align="center"><code>space x x</code></td><td align="center">all diagnostics</td></tr>
<tr><td align="center"><code>space f t</code></td><td align="center">floating terminal</td></tr>
<tr><td align="center"><code>space U</code></td><td align="center">undo tree</td></tr>
<tr><td align="center"><code>space u C</code></td><td align="center">change theme</td></tr>
<tr><td align="center"><code>space l</code></td><td align="center">plugin manager</td></tr>
<tr><td align="center"><code>space q q</code></td><td align="center">quit nvim</td></tr>
<tr><td align="center"><code>g c c</code></td><td align="center">comment the line</td></tr>
</tbody>
</table>

</div>

inside code files once a language server attaches

<div align="center">

<table align="center">
<thead>
<tr><th align="center">key</th><th align="center">what it does</th></tr>
</thead>
<tbody>
<tr><td align="center"><code>g d</code></td><td align="center">jump to the definition</td></tr>
<tr><td align="center"><code>g I</code></td><td align="center">jump to the implementation</td></tr>
<tr><td align="center"><code>g r</code></td><td align="center">find every reference</td></tr>
<tr><td align="center"><code>K</code></td><td align="center">show docs for what is under the cursor</td></tr>
<tr><td align="center"><code>space c a</code></td><td align="center">code actions</td></tr>
<tr><td align="center"><code>space c r</code></td><td align="center">rename the symbol everywhere</td></tr>
<tr><td align="center"><code>space c f</code></td><td align="center">format the file</td></tr>
<tr><td align="center"><code>space c d</code></td><td align="center">see the error on this line</td></tr>
</tbody>
</table>

</div>

git hunks

<div align="center">

<table align="center">
<thead>
<tr><th align="center">key</th><th align="center">what it does</th></tr>
</thead>
<tbody>
<tr><td align="center"><code>] h</code></td><td align="center">next hunk</td></tr>
<tr><td align="center"><code>[ h</code></td><td align="center">previous hunk</td></tr>
<tr><td align="center"><code>space g h s</code></td><td align="center">stage this hunk</td></tr>
<tr><td align="center"><code>space g h r</code></td><td align="center">reset this hunk</td></tr>
<tr><td align="center"><code>space g h p</code></td><td align="center">preview this hunk</td></tr>
</tbody>
</table>

</div>

## ✦ themes

ten themes written by hand and all living in `colors`

switch live with `space u C` or with `:colorscheme reham_violet`

<div align="center">

<table align="center">
<thead>
<tr><th align="center">theme</th><th align="center">look</th></tr>
</thead>
<tbody>
<tr><td align="center">◆ <code>reham_blue</code></td><td align="center">cold silver blue on near black</td></tr>
<tr><td align="center">◆ <code>reham_paper</code></td><td align="center">warm paper with soft contrast</td></tr>
<tr><td align="center">◆ <code>reham_sage</code></td><td align="center">muted sage green</td></tr>
<tr><td align="center">◆ <code>reham_green</code></td><td align="center">olive green</td></tr>
<tr><td align="center">◆ <code>reham_green_plus</code></td><td align="center">brighter green on the everforest palette</td></tr>
<tr><td align="center">◆ <code>reham_green_light</code></td><td align="center">light everforest on cream</td></tr>
<tr><td align="center">◆ <code>reham_honey</code></td><td align="center">amber and gold</td></tr>
<tr><td align="center">◆ <code>reham_rose</code></td><td align="center">dusty rose</td></tr>
<tr><td align="center">◆ <code>reham_violet</code></td><td align="center">deep violet with mint accents</td></tr>
<tr><td align="center">◆ <code>reham_teal</code></td><td align="center">deep teal and cyan</td></tr>
</tbody>
</table>

</div>

day and night can follow you with `space u K` which cycles auto day and night

## ✦ my commands

<sub>made by the developer</sub>

<div align="center">

<table align="center">
<thead>
<tr><th align="center">group</th><th align="center">command</th><th align="center">what it does</th></tr>
</thead>
<tbody>
<tr><td rowspan="2" align="center"><b>setup</b></td><td align="center"><code>:LspRestart</code></td><td align="center">restarts language servers when one hangs</td></tr>
<tr><td align="center"><code>:RehamCheck</code></td><td align="center">checks the setup and tells you if anything is broken</td></tr>
<tr><td rowspan="11" align="center"><b>files</b></td><td align="center"><code>:BufClean</code></td><td align="center">wipes hidden buffers left behind</td></tr>
<tr><td align="center"><code>:BufOnly</code></td><td align="center">closes every buffer except the current one</td></tr>
<tr><td align="center"><code>:ChmodX</code></td><td align="center">toggles the executable bit on the file</td></tr>
<tr><td align="center"><code>:DiffOrig</code></td><td align="center">diffs your edits against the saved file</td></tr>
<tr><td align="center"><code>:Dotfiles</code></td><td align="center">opens the nvim config folder</td></tr>
<tr><td align="center"><code>:FileInfo</code></td><td align="center">shows size encoding and line endings</td></tr>
<tr><td align="center"><code>:Reload</code></td><td align="center">restarts nvim</td></tr>
<tr><td align="center"><code>:RetabSpaces</code></td><td align="center">converts indentation to spaces</td></tr>
<tr><td align="center"><code>:RetabTabs</code></td><td align="center">converts indentation to tabs</td></tr>
<tr><td align="center"><code>:RunThis</code></td><td align="center">runs the current file</td></tr>
<tr><td align="center"><code>:Trim</code></td><td align="center">strips trailing whitespace</td></tr>
<tr><td rowspan="7" align="center"><b>text</b></td><td align="center"><code>:CopyCode</code></td><td align="center">copies the selection as a markdown code block</td></tr>
<tr><td align="center"><code>:CopyName</code></td><td align="center">copies just the file name</td></tr>
<tr><td align="center"><code>:CopyRef</code></td><td align="center">copies file path with line number</td></tr>
<tr><td align="center"><code>:Msg</code></td><td align="center">puts messages in a buffer you can copy</td></tr>
<tr><td align="center"><code>:UrlDecode</code></td><td align="center">decodes a url back to text</td></tr>
<tr><td align="center"><code>:UrlEncode</code></td><td align="center">encodes text so it can travel in a url</td></tr>
<tr><td align="center"><code>:UUID</code></td><td align="center">inserts a fresh uuid</td></tr>
<tr><td rowspan="3" align="center"><b>notes</b></td><td align="center"><code>:Daily</code></td><td align="center">opens today's note</td></tr>
<tr><td align="center"><code>:GrepNotes</code></td><td align="center">searches inside your notes</td></tr>
<tr><td align="center"><code>:Journal</code></td><td align="center">opens the notes folder</td></tr>
<tr><td rowspan="15" align="center"><b>git</b></td><td align="center"><code>:DiffBranch</code></td><td align="center">diffs your branch against the base branch</td></tr>
<tr><td align="center"><code>:DiffStaged</code></td><td align="center">reviews staged changes</td></tr>
<tr><td align="center"><code>:GitRoot</code></td><td align="center">jumps to the repo root</td></tr>
<tr><td align="center"><code>:YankBlame</code></td><td align="center">copies who last touched this line</td></tr>
<tr><td align="center"><code>:YankBranch</code></td><td align="center">copies the branch name</td></tr>
<tr><td align="center"><code>:YankCommit</code></td><td align="center">copies the latest commit hash</td></tr>
<tr><td align="center"><code>:YankDiff</code></td><td align="center">copies the full git diff</td></tr>
<tr><td align="center"><code>:YankDiffFile</code></td><td align="center">copies the diff of this file</td></tr>
<tr><td align="center"><code>:YankLog</code></td><td align="center">copies recent commits</td></tr>
<tr><td align="center"><code>:YankLogFile</code></td><td align="center">copies the commit history of this file</td></tr>
<tr><td align="center"><code>:YankLogGrep</code></td><td align="center">copies the history of a text search</td></tr>
<tr><td align="center"><code>:YankRemote</code></td><td align="center">copies the repo url</td></tr>
<tr><td align="center"><code>:YankStaged</code></td><td align="center">copies the staged diff</td></tr>
<tr><td align="center"><code>:YankStatus</code></td><td align="center">copies git status</td></tr>
<tr><td align="center"><code>:YankTag</code></td><td align="center">copies the latest tag</td></tr>
<tr><td rowspan="4" align="center"><b>ui</b></td><td align="center"><code>:Dashboard</code></td><td align="center">opens the home screen</td></tr>
<tr><td align="center"><code>:OpenSmartMenu</code></td><td align="center">opens the right click menu</td></tr>
<tr><td align="center"><code>:PluginList</code></td><td align="center">copies installed plugin names</td></tr>
<tr><td align="center"><code>:Streak</code></td><td align="center">shows how many days in a row you coded</td></tr>
<tr><td rowspan="17" align="center"><b>copies</b></td><td align="center"><code>:YankArgs</code></td><td align="center">copies the arglist files</td></tr>
<tr><td align="center"><code>:YankAutocmds</code></td><td align="center">copies the autocmd list</td></tr>
<tr><td align="center"><code>:YankBuffers</code></td><td align="center">copies paths of open buffers</td></tr>
<tr><td align="center"><code>:YankCmd</code></td><td align="center">copies the last command you typed</td></tr>
<tr><td align="center"><code>:YankCwd</code></td><td align="center">copies the working directory</td></tr>
<tr><td align="center"><code>:YankDiagnostics</code></td><td align="center">copies errors and warnings of this file</td></tr>
<tr><td align="center"><code>:YankEnv</code></td><td align="center">copies an environment variable value</td></tr>
<tr><td align="center"><code>:YankHealthErrors</code></td><td align="center">copies checkhealth errors</td></tr>
<tr><td align="center"><code>:YankLsp</code></td><td align="center">copies running language servers</td></tr>
<tr><td align="center"><code>:YankMarks</code></td><td align="center">copies global marks a to z</td></tr>
<tr><td align="center"><code>:YankOldfiles</code></td><td align="center">copies recently opened files</td></tr>
<tr><td align="center"><code>:YankQuickfix</code></td><td align="center">copies the quickfix list</td></tr>
<tr><td align="center"><code>:YankReg</code></td><td align="center">copies any register</td></tr>
<tr><td align="center"><code>:YankRuntime</code></td><td align="center">copies runtime paths</td></tr>
<tr><td align="center"><code>:YankSearch</code></td><td align="center">copies the last search</td></tr>
<tr><td align="center"><code>:YankTools</code></td><td align="center">copies versions of your tools</td></tr>
<tr><td align="center"><code>:YankWhich</code></td><td align="center">copies the path of any binary</td></tr>
</tbody>
</table>

</div>

## ✦ layout

<div align="center">

<table align="center">
<thead>
<tr><th align="center">folder</th><th align="center">what lives there</th></tr>
</thead>
<tbody>
<tr><td align="center"><code>lua/boot/</code></td><td align="center">startup wiring keymaps and the self check</td></tr>
<tr><td align="center"><code>lua/mods/</code></td><td align="center">plugins grouped by domain</td></tr>
<tr><td align="center"><code>lua/lib/</code></td><td align="center">small helpers</td></tr>
<tr><td align="center"><code>colors/</code></td><td align="center">the theme family</td></tr>
</tbody>
</table>

</div>

<div align="center">

<sub>apache 2.0 license</sub>

<sub>copyright © 2026 reham</sub>

</div>
