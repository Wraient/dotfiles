#!/usr/bin/env python3
import subprocess
import sys
import re
import os
import time
import httpx
from pypresence import Presence
import datetime

CLIENT_ID = "1084791136981352558"
ENDPONT = "https://kitsu.io/api/"

rpc_client = Presence(CLIENT_ID)
rpc_client.connect()

http_client = httpx.Client(base_url=ENDPONT)

(
    _,
    mpv_executable,
    anime_name,
    release_year,
    episode_count,
    content_stream,
    subtitle_stream,
    *opts,
) = sys.argv


anime = http_client.get("edge/anime", params={"filter[text]": anime_name, "filter[year]": f"{release_year}..{release_year}"}).json()[
    "data"
]

if not anime:
    raise SystemExit()

media = anime[0]["attributes"]
media_title = "%s %s" % (media["canonicalTitle"], "- Episode "+episode_count)

if subtitle_stream != "":
    args = [
        mpv_executable,
        content_stream,
        f"--force-media-title={media_title}",
        f"--sub-files={subtitle_stream}",
        "--msg-level=ffmpeg/demuxer=error",
    ] + opts
else:
    args = [
        mpv_executable,
        content_stream,
        f"--force-media-title={media_title}",
        "--msg-level=ffmpeg/demuxer=error",
    ] + opts


process = subprocess.Popen(
    args
)

if sys.platform == 'win32':
    file_path = os.path.join(os.environ['LocalAppData'], 'Temp', 'jerry_position')
else:
    file_path = '/tmp/jerry_position'

while True:
    with open(file_path, 'r') as file:
        content = file.read()
    pattern = r'(\(Paused\)\s)?AV:\s([0-9:]*) / ([0-9:]*) \(([0-9]*)%\)'
    matches = re.findall(pattern, content)
    # small_image = "https://images-ext-1.discordapp.net/external/dUSRf56flwFeOMFjafsUhIMMS_1Xs-ptjeDHo6TWn6c/%3Fquality%3Dlossless%26size%3D48/https/cdn.discordapp.com/emojis/1138835294506975262.png"
    if matches:
        if matches[-1][0] == "(Paused) ":
            elapsed = matches[-1][1]
        else:
            elapsed = matches[-1][1]
            # ftr = [3600,60,1]
            # elapsed = sum([a*b for a,b in zip(ftr, map(int,elapsed.split(':')))]) # convert time string to time seconds
            # the_time = int(time.time()) - int(elapsed)

        duration = matches[-1][2]
        position = f"{elapsed} / {duration}"
    else:
        position = "Just Started"
        elapsed="Just Started"
        # the_time = time.time()
    

    rpc_client.update(
        details=media_title,
        # details="Watching",
        state=position,
        # state=str(elapsed),
        large_image=media["posterImage"]["original"],
        large_text=media_title,
        # start=the_time,
        # small_image=small_image,
        small_text=f"Episode {episode_count}",
        buttons=[{"label":"Join me <3", "url":"https://www.youtube.com/watch?v=dQw4w9WgXcQ"}]
    )

    if process.poll() is not None:
        break

process.wait()
