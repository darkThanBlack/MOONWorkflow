
on run argv
  tell application "Xcode"
    -- load
    set space to first workspace document where its name contains "XMApp"
    repeat 60 times
      if loaded of space is true then
        exit repeat
      end if
      delay 0.5
    end repeat
    -- clean
    set clean_result to clean space
    repeat
      if completed of clean_result is true then
        exit repeat
      end if
      delay 0.5
    end repeat
    -- build sub proj
    repeat with i in argv
      set proj_name to contents of i
        set exist_scheme to first schemes of space where its name is proj_name
        set active scheme of space to exist_scheme
        delay 0.5
        set build_result to build space
        repeat
          if completed of build_result is true then
            exit repeat
          end if
          delay 0.5
        end repeat
      delay 1
    end repeat
    -- build main proj
    set main_scheme to first schemes of space where its name is "XMApp"
    set active scheme of space to main_scheme
    delay 0.5
    set build_result to build space
    repeat
      if completed of build_result is true then
        exit repeat
      end if
      delay 0.5
    end repeat
  end tell
end run