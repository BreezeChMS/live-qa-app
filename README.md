# Cloud Live QA
Take any Linux box or vm and convert it into a Docker-powered system to spin up new QA environments for each branch, pull in changes anytime the branch is updated, and delete the environment when the branch's pull request has been merged.

## Installation

__Pre-requisites:__
- Ubuntu 18+, 20+
- [Docker](https://docs.docker.com/engine/install/ubuntu/), [Docker-Compose](https://docs.docker.com/compose/install/), and Git installed
- Wilcard second-level domain DNS pointing to this system

__Instructions:__

1. Copy the files from this repository into the system root. It would look like `/docker` and `/hooks`, respectively.

2. Create the global network that each environment will use to give subdomain access:
	```
	docker network create nginx-proxy
	```

3. Start the main Docker NGINX/SSL process:
	```
	docker-compose -f /docker/nginx.docker-compose.yaml up -d
	```

4. Setup the git repository
	```
	mkdir /docker/repo
	git clone https://[GITHUB_USERNAME]:[GITHUB_TOKEN]@github.com/[GITHUB_REPOSITORY] /docker/repo
	```

5. Install Webhooks package and configure script permissions
	```
	sudo apt-get install webhook
	chmod +x /hooks/scripts/new.sh
	chmod +x /hooks/scripts/sync.sh
	chmod +x /hooks/scripts/delete.sh
	```

6. Start Webhooks
	```
	# Run in the background
	/usr/bin/webhook -hooks /hooks/hooks.json > /dev/null 2>&1 &

	# Run in debugging mode
	/usr/bin/webhook -hooks /hooks/hooks.json -verbose
	```

## Usage
With Webhooks running, you can reach the API through `http://[YOUR_DOMAIN]:9000`. Here are the endpoints you can use:

- New Environment
	```
	POST: /hooks/new
	JSON: {
		"pr": [PR_NUMBER]
		"branch": [BRANCH_NAME]
		}
	```

- Update Environment
	```
	POST: /hooks/sync
	JSON: {
		"pr": [PR_NUMBER]
		}
	```

- Delete Environment
	```
	POST: /hooks/delete
	JSON: {
		"pr": [PR_NUMBER]
		}
	```

### GitHub Action
Here's the [GitHub Action](https://github.com/christianpatrick/live-qa-action/) to automate all of this.
