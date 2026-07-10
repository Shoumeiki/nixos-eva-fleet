{ pkgs, theme, ... }:
let
  c = theme.palette.hexH;
  # Canonical base16 -> Neovim highlight mapping (base16-vim convention).
  highlightLua = ''
    local hl = vim.api.nvim_set_hl
    hl(0, "Normal",       { fg = "${c.base05}", bg = "${c.base00}" })
    hl(0, "NormalFloat",  { fg = "${c.base05}", bg = "${c.base01}" })
    hl(0, "Comment",      { fg = "${c.base03}", italic = true })
    hl(0, "Constant",     { fg = "${c.base09}" })
    hl(0, "String",       { fg = "${c.base0B}" })
    hl(0, "Character",    { fg = "${c.base0B}" })
    hl(0, "Identifier",   { fg = "${c.base08}" })
    hl(0, "Function",     { fg = "${c.base0D}" })
    hl(0, "Statement",    { fg = "${c.base0E}" })
    hl(0, "Keyword",      { fg = "${c.base0E}" })
    hl(0, "PreProc",      { fg = "${c.base0A}" })
    hl(0, "Type",         { fg = "${c.base0A}" })
    hl(0, "Special",      { fg = "${c.base0C}" })
    hl(0, "Underlined",   { fg = "${c.base08}", underline = true })
    hl(0, "Error",        { fg = "${c.base08}", bold = true })
    hl(0, "Todo",         { fg = "${c.base00}", bg = "${c.base0A}" })
    hl(0, "LineNr",       { fg = "${c.base03}" })
    hl(0, "CursorLineNr", { fg = "${c.base0A}" })
    hl(0, "CursorLine",   { bg = "${c.base01}" })
    hl(0, "Visual",       { bg = "${c.base02}" })
    hl(0, "Search",       { fg = "${c.base00}", bg = "${c.base0A}" })
    hl(0, "IncSearch",    { fg = "${c.base00}", bg = "${c.base09}" })
    hl(0, "Pmenu",        { fg = "${c.base05}", bg = "${c.base01}" })
    hl(0, "PmenuSel",     { fg = "${c.base00}", bg = "${c.base0D}" })
    hl(0, "StatusLine",   { fg = "${c.base05}", bg = "${c.base02}" })
    hl(0, "DiffAdd",      { fg = "${c.base0B}" })
    hl(0, "DiffChange",   { fg = "${c.base0E}" })
    hl(0, "DiffDelete",   { fg = "${c.base08}" })
    hl(0, "GitSignsAdd",    { fg = "${c.base0B}" })
    hl(0, "GitSignsChange", { fg = "${c.base0E}" })
    hl(0, "GitSignsDelete", { fg = "${c.base08}" })
  '';
in
{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;

    extraPackages = with pkgs; [
      nil
      nixfmt
      lua-language-server
      stylua
      ripgrep
      fd
    ];

    plugins = with pkgs.vimPlugins; [
      # Syntax and parsing
      (nvim-treesitter.withPlugins (
        p: with p; [
          nix
          lua
          vim
          vimdoc
          bash
          fish
          json
          yaml
          toml
          markdown
          markdown_inline
          python
          rust
          # "c" grammar omitted: broken `.meta` attribute in the pinned
          # nixpkgs revision (grammar.meta missing in neovim/utils.nix)
          cpp
          go
          javascript
          typescript
          html
          css
        ]
      ))

      # LSP client
      nvim-lspconfig

      # Fuzzy search
      telescope-nvim
      plenary-nvim

      # Statusline
      lualine-nvim

      # Git
      gitsigns-nvim

      # QoL
      which-key-nvim
      nvim-autopairs
      comment-nvim
      indent-blankline-nvim
    ];

    initLua = ''
      -- Colorscheme (hand-authored from the active palette)
      vim.opt.termguicolors = true
      ${highlightLua}

      -- Editor options
      vim.g.mapleader = " "
      vim.g.maplocalleader = "\\"

      local opt = vim.opt
      opt.number = true
      opt.relativenumber = true
      opt.mouse = "a"
      opt.clipboard = "unnamedplus"   -- share clipboard with system
      opt.expandtab = true
      opt.shiftwidth = 2
      opt.tabstop = 2
      opt.smartindent = true
      opt.ignorecase = true
      opt.smartcase = true
      opt.signcolumn = "yes"
      opt.scrolloff = 8
      opt.updatetime = 250
      opt.timeoutlen = 400
      opt.undofile = true
      opt.splitright = true
      opt.splitbelow = true

      -- Clear search highlight on <Esc>
      vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")


      -- Plugin setup
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "nix", "lua", "vim", "bash", "fish", "json", "yaml", "toml", "markdown", "python", "rust", "c", "cpp", "go", "javascript", "typescript", "html", "css" },
        callback = function()
          vim.treesitter.start()
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })

      require("lualine").setup({ options = { theme = "auto" } })

      require("gitsigns").setup()
      require("which-key").setup()
      require("nvim-autopairs").setup()
      require("Comment").setup()
      require("ibl").setup()


      -- Telescope
      local telescope = require("telescope.builtin")
      vim.keymap.set("n", "<leader>ff", telescope.find_files, { desc = "Find files" })
      vim.keymap.set("n", "<leader>fg", telescope.live_grep,  { desc = "Live grep" })
      vim.keymap.set("n", "<leader>fb", telescope.buffers,    { desc = "Buffers" })
      vim.keymap.set("n", "<leader>fh", telescope.help_tags,  { desc = "Help tags" })


      -- LSP
      vim.lsp.config("nil_ls", {
        settings = {
          ["nil"] = {
            formatting = { command = { "nixfmt" } },
          },
        },
      })
      vim.lsp.enable("nil_ls")

      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
          },
        },
      })
      vim.lsp.enable("lua_ls")

      -- Buffer-local LSP keybinds on attach
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local map = function(lhs, rhs, desc)
            vim.keymap.set("n", lhs, rhs, { buffer = args.buf, desc = desc })
          end
          map("gd", vim.lsp.buf.definition,       "Go to definition")
          map("gr", vim.lsp.buf.references,       "References")
          map("K",  vim.lsp.buf.hover,            "Hover")
          map("<leader>rn", vim.lsp.buf.rename,   "Rename symbol")
          map("<leader>ca", vim.lsp.buf.code_action, "Code action")
          map("[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, "Prev diagnostic")
          map("]d", function() vim.diagnostic.jump({ count =  1, float = true }) end, "Next diagnostic")
        end,
      })

      -- Format on save for buffers with an attached LSP that supports it
      vim.api.nvim_create_autocmd("BufWritePre", {
        callback = function(args)
          local clients = vim.lsp.get_clients({ bufnr = args.buf })
          for _, client in ipairs(clients) do
            if client:supports_method("textDocument/formatting") then
              vim.lsp.buf.format({ bufnr = args.buf, async = false })
              return
            end
          end
        end,
      })
    '';
  };
}
