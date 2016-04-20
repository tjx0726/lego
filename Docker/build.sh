echo 'Regenerating dockerfile with UID...'
mv Dockerfile Dockerfile.old
( echo '### DO NOT EDIT DIRECTLY, SEE Dockerfile.template ###'; sed -e "s/<<UID>>/$UID/" < Dockerfile.lego.template ) > Dockerfile
docker build -t $USER/lego .
