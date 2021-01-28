if [ ! -d "json_files/" ]; then
    mkdir json_files
fi
if [ ! -d *.jsonepg ]; then
    echo 没有找到节目单~
    exit
fi
mv *.jsonepg json_files/
if [ ! -d fullepgs.json ]; then
    touch fullepgs.json
fi
jq -s 'reduce .[] as $item ({}; . * $item)' json_files/* > fullepgs.json
rm -f json_files/*