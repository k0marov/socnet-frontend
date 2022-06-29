trap "rm -rf go-socnet && rm -rf static && cd .. && rm -rf go-socnet && rm -rf static" EXIT
rm -r static
mkdir static
rm -rf go-socnet

git clone https://github.com/k0marov/go-socnet.git
cd go-socnet

go get -u ./...

SOCIO_STATIC_DIR=../static SOCIO_STATIC_HOST=static.example.com go run deploy/main.go
