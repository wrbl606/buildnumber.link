deploy:
	(cd site; npm run build)
	rm -rf public/
	mkdir -p public
	cp -r site/dist/ public/
	devil www restart buildnumber.link