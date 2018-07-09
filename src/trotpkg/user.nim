import ospaths
import httpclient
import strutils, sequtils
import nre, options

import types
export types.colorData

let
  regex = re".*<rect.*>.*"
  reColor = re"#\w{6}"
  reDate = re"\d{4}-\d{1,2}-\d{1,2}"
  URI = "https://github.com/users/$1/contributions"

  http_proxy = if existsEnv("http_proxy"): getEnv("http_proxy") else: nil
  client = newHttpClient(proxy = if http_proxy.isNil: nil else: newProxy(http_proxy))

proc userContributions*(user: string): seq[colorData] =
  let body = client.getContent(URI % user)
  result = @[]
  for i in body.strip().split("\n"):
    let r = i.match(regex)
    if not r.isNone:
      let tmp: colorData = (
        $($r.get()).find(reDate).get(),
        $($r.get()).find(reColor).get()
      )

      result.add(tmp)

if isMainModule:
  for i in userContributions("nve3pd"):
    echo i
