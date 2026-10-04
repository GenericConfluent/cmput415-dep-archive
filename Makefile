build:
	mkdir -p "./lib415"
	podman run --rm \
		-v ./targen.sh:/tmp/targen.sh:Z \
		-v ./lib415:/tmp/lib415:Z \
		dev415 /bin/bash -c "TARGEN_DIR=/tmp/lib415 /tmp/targen.sh"
	tar -czvf lib415.tar.gz "./lib415"

clean: 
	rm -r lib415*
