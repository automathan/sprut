# This script exports each visible layer in the input file to their respective separate sprite sheet
# The resulting sheet will be named after the aseprite file and the layer, separated by underscore

$file = $args[0]
$name = $file.split("\")[-1].split(".")[0]
echo "Splitting and exporting $name ($file)"
Aseprite.exe -b --list-layers "$file" | ForEach-Object {Aseprite.exe -b --layer="$_" "$file" --sheet "export/$($name)_$_.png" --data "metadata/$($name)_$_.json"}
