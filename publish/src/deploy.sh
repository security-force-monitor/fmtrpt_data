#!/bin/bash
#
# Deploy FMTRPT data to Heroku
# 
# tl@sfm 	2024-11	Small refactor
#
# Requires datasette and heroku cli installed locally
# Requires db to be created using src/createdb.src first


set -euo pipefail

_publishHerokuProduction () {

	# datasette publish doens't yet accept --team flag
	# so set default team for your account if needed. 
	# See: https://devcenter.heroku.com/articles/develop-orgs#setting-a-default-team

	datasette publish heroku src/state-department-data.db \
		--metadata src/metadata.yaml \
		--name "fmtrpt-2022" \
		--extra-options="--setting default_page_size 50" \
		--extra-options="--setting sql_time_limit_ms 40000" \
		--extra-options="--setting suggest_facets off" \
		--extra-options="--setting allow_csv_stream on" \
		--extra-options="--setting max_returned_rows 100000"
}

_publishHerokuTest () {

	datasette publish heroku src/state-department-data.db \
		--metadata src/metadata.yaml \
		--name "fmtrpt" \
		--extra-options="--setting default_page_size 50" \
		--extra-options="--setting sql_time_limit_ms 30000" \
		--extra-options="--setting suggest_facets off" \
		--extra-options="--setting allow_csv_stream off"
}

_publishLocal () {

	datasette serve src/state-department-data.db \
		--metadata src/metadata.yaml \
		--setting default_page_size "50" \
		--setting sql_time_limit_ms "10000" \
		--setting suggest_facets "off" \
		--setting allow_csv_stream "off"
}


_main () {

	# Various options here, uncheck as needed:
	# - production server
	# - test project
	# - local server

#	_publishHerokuProduction
#	_publishHerokuTest
	_publishLocal



}

_main
