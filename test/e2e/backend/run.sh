trap "rm -rf go-socnet && cd .. && rm -rf go-socnet" EXIT
mkdir static
rm -rf go-socnet

git clone https://github.com/k0marov/go-socnet.git
cd go-socnet

go get -u ./...

SOCIO_STATIC_DIR=../static SOCIO_STATIC_HOST=static.example.com go run deploy/main.go