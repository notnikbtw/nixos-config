return {
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    config = function()
      require("gruvbox").setup({ contrast = "hard", transparent_mode = false })
      vim.cmd.colorscheme("gruvbox")
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = { options = { theme = "gruvbox", globalstatus = true } },
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = {},
  },
  {
    "echasnovski/mini.pairs",
    version = false,
    opts = {},
  },
}
