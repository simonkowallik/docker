# intro
super simple web app using node to receive multipart/form-data file uploads.

# build docker image

	docker build -t demo-node-fileupload .

# run docker container

	docker run --rm -p 8080:80 demo-node-fileupload

# upload a file

using curl:

	# curl -XPOST http://<containerip>:8080/upload -F sampleFile=@file.txt

response:

	filename:file.txt, mimetype:text/plain, truncated:false, length:2, md5:50585be4e3159a71c874c590d2ba12ec

 or point your browser to http://<containerip>:8080/upload