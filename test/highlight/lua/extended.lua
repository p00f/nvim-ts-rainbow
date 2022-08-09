local M = {}
-- hl     11

      if 1 == 2 then
-- hl 11        1111
        print("Something is wrong")
        --hl 2                    2
    end
--hl111

function M.setup(opts)
    -- hl       1    1
    opts = vim.tbl_extend("force", {
        -- hl            1         2
        debug_level = "error",
    }, opts)
--hl2      1

    if opts.debug_level == "error" then
--hl11                             1111
        if opts.another_option then
    --hl22                     2222
            print("abc")
            --hl 3     3
        end
    --hl222
        print("Error debug level")
        --hl 2                   2
    elseif opts.debug_level == "info" then
--hl111111                            1111
        print("Info debug level")
        --hl 2                  2
    else
--hl1111
        print("Another debug level", opts.debug_level)
        --hl 2                                       2
    end
--hl111
end

return M
