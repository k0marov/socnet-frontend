mkdir workdir
cd workdir

rm -r static
mkdir static
rm -rf go-socnet

git clone https://github.com/k0marov/go-socnet.git
cd go-socnet

go get -u ./...
go build -o ../main deploy/main.go
