return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-neotest/nvim-nio",
      "williamboman/mason.nvim",
      -- "jay-babu/mason-nvim-dap.nvim",
    },
    config = function()
      local dap = require "dap"
      local ui = require "dapui"

      require("dapui").setup()
      -- require("dap-go").setup()

      require("nvim-dap-virtual-text").setup {
        -- This just tries to mitigate the chance that I leak tokens here. Probably won't stop it from happening...
        -- display_callback = function(variable)
        --   local name = string.lower(variable.name)
        --   local value = string.lower(variable.value)
        --   if name:match "secret" or name:match "api" or value:match "secret" or value:match "api" then
        --     return "*****"
        --   end

        --   if #variable.value > 15 then
        --     return " " .. string.sub(variable.value, 1, 15) .. "... "
        --   end

        --   return " " .. variable.value
        -- end,
      }

      -- dap.adapters.chrome = {
      --     type = "executable",
      --     command = "node",
      --     args = {os.getenv("HOME") .. "personal/vscode-chrome-debug/out/src/chromeDebug.js"} -- TODO adjust
      -- }

      -- dap.configurations.javascript = {
      --     {
      --         type = "chrome",
      --         request = "attach",
      --         program = "${file}",
      --         cwd = vim.fn.getcwd(),
      --         sourceMaps = true,
      --         protocol = "inspector",
      --         port = 9222,
      --         webRoot = "${workspaceFolder}"
      --     }
      -- }

      local bin_locations = vim.fn.stdpath("data") .. "/mason/bin/"
      vim.print(bin_locations)
      dap.adapters.codelldb = {
        -- type = 'executable',
        -- attach = {
        --   pidProperty = "pid",
        --   pidSelect = "ask"
        -- },
        -- command = 'lldb',
        -- env = {
        --   LLDB_LAUNCH_FLAG_LAUNCH_IN_TTY = "YES"
        -- },
        -- name = "lldb"
        type = "server",
        port = 13000,
        host = "127.0.0.1",
        executable = {
        command = bin_locations .. "codelldb",
        args = { "--port", 13000 },
        },
      }

      dap.configurations.cpp = {
        {
          -- name = "lldb",
          -- type = "cpp",
          -- request = "launch",
          -- program = function()
          --   return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
          -- end,
          -- cwd = '${workspaceFolder}',
          -- externalTerminal = false,
          -- stopOnEntry = false,
          -- args = {}
          --
          -- name = "Launch file",
          type = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd = "${workspaceFolder}",
          externalTerminal = false,
          stopOnEntry = false,
          runInTerminal = false,
        },
      }


      vim.keymap.set("n", "<space>b", dap.toggle_breakpoint)
      vim.keymap.set("n", "<space>gb", dap.run_to_cursor)

      -- Eval var under cursor
      vim.keymap.set("n", "<space>?", function()
        require("dapui").eval(nil, { enter = true })
      end)

      vim.keymap.set("n", "<F1>", dap.continue)
      vim.keymap.set("n", "<F2>", dap.step_into)
      vim.keymap.set("n", "<F3>", dap.step_over)
      vim.keymap.set("n", "<F4>", dap.step_out)
      vim.keymap.set("n", "<F5>", dap.step_back)
      vim.keymap.set("n", "<F13>", dap.restart)

      dap.listeners.before.attach.dapui_config = function()
        ui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        ui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        ui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        ui.close()
      end
    end,
  },
}
