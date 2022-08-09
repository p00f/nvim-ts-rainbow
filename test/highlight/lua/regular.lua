local M = {}
-- hl     11

  if 1 == 2 then
    print("Something is wrong")
    --hl 2                    2
end

function M.setup(opts)
    -- hl       1    1
    opts = vim.tbl_extend("force", {
        -- hl            1         2
        debug_level = "error",
    }, opts)
--hl2      1

    if opts.debug_level == "error" then
        if opts.another_option then
            print("abc")
            --hl 3     3
        end
        print("Error debug level")
        --hl 2                   2
    elseif opts.debug_level == "info" then
        print("Info debug level")
        --hl 2                  2
    else
        print("Another debug level", opts.debug_level)
        --hl 2                                       2
    end
end

return M
