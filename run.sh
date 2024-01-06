if [ -f script_executed.flag ]; then
	echo "Script has already been executed. Exiting..."
	exit 0
fi

if docker compose up -d; then
	docker compose run web rake db:create
	docker compose run web rake db:migrate
	docker compose run web rake db:seed

	touch script_executed.flag
else
	echo "Failed to start containers.Exiting..."
	exit 1
fi
