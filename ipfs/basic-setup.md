# ipfs

## install
    snap install ipfs

## configure
    ipfs config --json API.HTTPHeaders.Access-Control-Allow-Origin '["http://localhost:8080", "http://localhost:3000", "http://127.0.0.1:5001", "https://webui.ipfs.io"]'

    ipfs config --json API.HTTPHeaders.Access-Control-Allow-Methods '["PUT", "POST"]'

## start
    ipfs daemon

## Access via tunnel
    ssh -L 8080:localhost:5001 ubuntu@ipfs-server
    xdg-open http://localhost:8080/webui
