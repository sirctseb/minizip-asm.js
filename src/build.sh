echo "Beginning Build:"
cd ..

echo "Copy external library..."
cp -r external/zlib .
rm -r zlib/contrib/minizip
cp -r external/minizip zlib/contrib
cp src/main.cpp zlib/contrib/minizip
cp src/main_pre.js zlib/contrib/minizip
cp src/main_post.js zlib/contrib/minizip

echo "Clear output folder..."
rm -r lib
mkdir lib

echo "Make zlib..."
cd zlib
emconfigure ./configure
# emmake make

echo "Make aes..."
cd contrib/minizip/aes
# emcc aescrypt.c -o aescrypt.o -O
# emcc aeskey.c -o aeskey.o -O
# emcc aestab.c -o aestab.o -O
# emcc entropy.c -o entropy.o -O
# emcc fileenc.c -o fileenc.o -O
# emcc hmac.c -o hmac.o -O
# emcc prng.c -o prng.o -O
# emcc pwd2key.c -o pwd2key.o
# emcc sha1.c -o sha1.o -O
# emcc aescrypt.o aeskey.o aestab.o entropy.o fileenc.o hmac.o prng.o pwd2key.o sha1.o -o ../libaes.o

echo "Make minizip..."
cd ..
emcc zip.c -o zip.o -O -I../..
emcc unzip.c -o unzip.o -O -I../..
emcc ioapi_mem.c -o ioapi_mem.o -O -I../..
emcc ioapi.c -o ioapi.o -O -I../..
emcc -s USE_ZLIB=1 -O -I../.. -o ../../../lib/minizip.js main.cpp --memory-init-file 0 -s ALLOW_MEMORY_GROWTH=1 -s NO_FILESYSTEM=0 -s EXPORTED_FUNCTIONS="['_list', '_extract', '_append']" --pre-js main_pre.js --post-js main_post.js zip.o unzip.o ioapi.o ioapi_mem.o -Oz

echo "Finished Build!\nPlease type command 'npm run finalbuild' to complete build."
cd ../../..
rm -r zlib
