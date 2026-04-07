mp.add_key_binding("Ctrl+DEL", "delete_file", function()
    local path = mp.get_property("path")

    if not path or not path:match("^/") then
        mp.osd_message("Not a local file")
        return
    end

    local cmd = string.format(
        'zenity --question --text="Delete this file?\n%s"',
        path
    )

    local res = os.execute(cmd)

    if res == 0 then
        os.remove(path)
        mp.osd_message("Deleted")
        mp.command("stop")
        mp.command("playlist-next")
    else
        mp.osd_message("Canceled")
    end
end)
