#!/bin/bash

cd /home/app/webapp

SCHEMA_VERSION=`chpst -u app bundle exec rails runner "puts ActiveRecord::Migrator.current_version" | tail -1`

chpst -u app bundle exec rake db:create

if [ "$SCHEMA_VERSION" -eq "0" ] ; then
  chpst -u app bundle exec rails db:environment:set
  chpst -u app bundle exec rake db:schema:load
  exit 0
fi

if bundle show rails_migrate_mutex; then
  chpst -u app bundle exec rake db:migrate:mutex
else
  chpst -u app bundle exec rake db:migrate
fi
