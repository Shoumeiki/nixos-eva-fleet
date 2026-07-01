{ pkgs, ... }:
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
          c
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
      opt.termguicolors = true
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
