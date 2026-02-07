return {
  'zbirenbaum/copilot.lua',
  requires = {
    'copilotlsp-nvim/copilot-lsp', -- (optional) for NES functionality
  },
  config = {
    suggestion = { enabled = false },
    panel = { enabled = false },
  },
}
