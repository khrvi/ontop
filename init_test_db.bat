echo drop test database ...
mysqladmin -u root drop assembla_test
echo drop test database done.

echo create test database ...
mysqladmin -u root create assembla_test
echo create test database done.

echo prepare database ...
rake db:test:prepare --trace
echo prepare database done.
