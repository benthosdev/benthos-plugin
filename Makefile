all: clean target

clean:
	@rm -rf target tmp/bin tmp/benthos-*.zip

target:
	@mkdir -p tmp/bin
	@goreleaser build --single-target --snapshot --id benthos \
		--output ./tmp/bin/benthos
	@GOARCH=amd64 GOOS=linux \
		goreleaser build --rm-dist --single-target --snapshot --id benthos-lambda-al2 \
		--output ./tmp/bin/bootstrap
	@zip -m -j tmp/benthos-lambda-al2_linux_amd64.zip ./tmp/bin/bootstrap
	@GOARCH=arm64 GOOS=linux \
		goreleaser build --rm-dist --single-target --snapshot --id benthos-lambda-al2 \
		--output ./tmp/bin/bootstrap
	@zip -m -j tmp/benthos-lambda-al2_linux_arm64.zip ./tmp/bin/bootstrap

test:
	@go test ./...

lint:
	@golangci-lint run

format:
	@golangci-lint run --fix

.PHONY: clean format lint test
