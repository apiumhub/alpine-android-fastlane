default: docker_build

docker_build:
	@docker build \
		-t apiumhub/android-fastlane-firebase-cli \
		--build-arg VCS_REF=`git rev-parse --short HEAD` .
