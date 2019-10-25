serve:
	parcel ./src/index.html

deploy:
	rm -rf ./dist
	parcel build ./src/index.html
	aws s3 sync ./dist "s3://$$(cd infra && terraform output s3_bucket)/"
