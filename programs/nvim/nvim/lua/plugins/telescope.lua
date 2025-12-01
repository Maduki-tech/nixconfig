return {
  "nvim-telescope/telescope.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    { "<leader>sf", LazyVim.pick("files"), desc = "Find Files" },
  },
}
