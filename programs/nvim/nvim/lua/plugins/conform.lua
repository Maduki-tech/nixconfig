return {
  "stevearc/conform.nvim",
  keys = {
    {
      "<leader>tf",
      function()
        require("conform").format()
      end,
      desc = "Format file",
    },
  },
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      javascript = { "prettierd" },
      typescript = { "prettierd" },
      json = { "prettierd" },
      html = { "prettierd" },
      css = { "prettierd" },
      scss = { "prettierd" },
      markdown = { "markdownfmt" },
      java = { "clang_format" },
    },
  },
}
