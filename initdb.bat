echo drop database ...
mysqladmin -u root drop assembla_development
echo drop database done.

echo create database ...
mysqladmin -u root create assembla_development --default-character-set=utf8
echo --default-character-set=utf8 
echo create database done.

echo migrate ...
rake db:migrate --trace
echo migrate done