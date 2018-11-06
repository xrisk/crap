import
  os,
  strformat,
  times

proc trash*(path: string) =
  var trashHome: string
  let fullPath= expandFilename(path)

  if existsEnv("XDG_DATA_HOME"):
    trashHome = joinPath(getEnv("XDG_DATA_HOME"), "Trash")
  else:
    trashHome = joinPath(getHomeDir(), ".local/share/Trash")
  moveFile(fullPath, fmt("{trashHome}/files/{path}"))

  let 
    t = getTime()
    formattedTime = t.format("yyyy-MM-dd") & "T" & t.format("HH:MM:ss")

  var trashInfo = fmt"""[Trash Info]
Path={fullPath}
DeletionDate={formattedTime}"""

  writeFile(joinPath(trashHome, "info", fmt"{path}.info"), trashInfo)

when isMainModule:
  var del: string
  try:
    for f in countUp(1, paramCount()):
      del = paramStr(f)
      trash(del)
  except IndexError:
    echo("error: no path specified")
    quit(0)
  except OSError:
    echo("error: no such file or directory")
    quit(0)