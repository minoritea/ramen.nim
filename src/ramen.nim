import
  std/cmdline, std/syncio, std/strformat, std/paths, std/unicode

if paramCount() != 1:
  let processName = paramStr(0).Path.extractFileName().string
  quit(fmt"Usage:  {processName} <program source>")

let src = paramStr(1).open()

const ramen = 127836.Rune

var line: string
var commands: seq[int]
while src.readLine(line):
  var tokenLen = 0
  for r in line.toRunes():
    if r == ramen:
      tokenLen.inc()
    elif tokenLen > 0:
      commands.add(tokenLen)
      tokenLen = 0

var heap: seq[int]
var heapPtr = 0
var commandPos = 0
while commandPos < commands.len:
  let command = commands[commandPos]
  case command
  of 1:
    heap[heapPtr].inc()
  of 2:
    heap[heapPtr].dec()
  of 3:
    heapPtr.inc()
    if heapPtr >= heap.len:
      heap.setLen(heapPtr + 1)
  of 4:
    if heapPtr < 1:
      quit("heap underflow")
    heapPtr.dec()
  of 5:
    var result: seq[char]
    while true:
      result.add stdin.readChar()
      if result.validateUtf8() < 0:
        break
      if result.len() > 4:
        quit("input too long")
    heap[heapPtr] = result.runeAt(0).int32
  of 6:
    stdout.write(heap[heapPtr].int32.Rune)
  of 7:
    if heap[heapPtr] == 0:
      while true:
        commandPos.inc()
        if commandPos >= commands.len:
          quit("cannot find the end of the block")
        if commands[commandPos] == 8:
          break
      commandPos.dec()
  of 8:
    if heap[heapPtr] != 0:
      while true:
        commandPos.dec()
        if commandPos < 0:
          quit("cannot find the beginning of the block")
        if commands[commandPos] == 7:
          break
      commandPos.dec()
  else:
    quit(fmt"unknown command: {command}")
  commandPos.inc()
