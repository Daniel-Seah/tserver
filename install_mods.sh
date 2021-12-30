#/bin/bash

# Download mods
for m in $@
do
  wget "http://javid.ddns.net/tModLoader/download.php?Down=mods/${m}.tmod" -O "${m}.tmod"
done

# Create json array of enabled mods
JSON=""
for m in $@
do
  JSON="$JSON, \"$m\""
done
JSON=${JSON:2}
echo "[$JSON]" > enabled.json
