return {
  "saghen/blink.cmp",
  build = "cargo +nightly build --release",
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    completion = {
      menu = {
        border = "rounded",
        draw = {
          treesitter = { "lsp" },
        },
      },
    },
    keymap = {
      ["<C-k>"] = { "select_prev", "fallback" },
      ["<C-j>"] = { "select_next", "fallback" },
      ["<C-h>"] = { "show_signature", "hide_signature", "fallback" },
      preset = "enter",
    },
  },
}
