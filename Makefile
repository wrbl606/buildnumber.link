deploy:
	cd site
	npm run build
	mkdir -p ../public
	cp -r dist/ ../public
	cd ..
	devil www restart buildnumber.link